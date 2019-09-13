data "external" "user_auth" {
  program = ["bash", "${path.module}/ssh.sh"]

  query = {
    host = esxi_guest.kube-masters[0].ip_address
  }

  depends_on = [esxi_guest.kube-masters]
}

data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig.tpl")

  vars = {
    kubeconfig_name           = local.kubeconfig_name
    endpoint                  = esxi_guest.kube-masters[0].ip_address
    cluster_auth_base64       = data.external.user_auth.result["certificate-authority-data"]
    client-certificate-data = data.external.user_auth.result["client-certificate-data"]
    client-key-data = data.external.user_auth.result["client-key-data"]
  }
}

data "ignition_user" "cluster_user" {
  count    = local.master_group_count

  name = "core"

  # forget how to configure this
  #password_hash = "$6$rounds=4096$v28up9xdAO$aLCyf/FfGU72QsOlJN60CyXH5yuyJ/f6WWeW3wyvPjHt4uDOUFbFCxchrf9FCUkUdng7bwZbonBk7aOFQ8Bcm0" # test1234

  ssh_authorized_keys = [lookup(
    var.master_groups[count.index],
    "key_file",
    local.workers_group_defaults_defaults["key_file"]
  )]
}

data "ignition_file" "cluster-init" {
  filesystem = "root"
  path = "/opt/cluster-init.sh"
  content {
      content = "${file("${path.module}/files/cluster-init.sh")}"
  }
}

data "ignition_systemd_unit" "setup-master" {
  name = "setup-master.service"
  content = file("${path.module}/files/setup-master.service")
}

data "ignition_config" "coreos" {
  count    = local.master_group_count

  users = [
    data.ignition_user.cluster_user[count.index].id
  ]

  files = [
    data.ignition_file.cluster-init.id
  ]

  systemd = [
    data.ignition_systemd_unit.setup-master.id
  ]
}
