data "template_file" "bootstrap" {
  template = file("${path.module}/../templates/bootstrap.service.tpl")

  vars = {
    type = var.type
    k8s_version = var.k8s_version
  }
}

data "ignition_user" "cluster_user" {
  name = "core"

  # forget how to configure this
  #password_hash = "$6$rounds=4096$v28up9xdAO$aLCyf/FfGU72QsOlJN60CyXH5yuyJ/f6WWeW3wyvPjHt4uDOUFbFCxchrf9FCUkUdng7bwZbonBk7aOFQ8Bcm0" # test1234

  ssh_authorized_keys = [
    var.key_file
  ]

  # ssh_authorized_keys = [lookup(
  #   var.master_groups[count.index],
  #   "key_file",
  #   local.["key_file"]
  # )]
}

data "ignition_file" "cluster-init" {
  filesystem = "root"
  path = "/opt/cluster-init.sh"
  content {
    content = "${file("${path.module}/../files/cluster-init.sh")}"
  }
}

data "ignition_systemd_unit" "bootstrap-service" {
  name = "bootstrap.service"
  content = data.template_file.bootstrap.rendered
}

data "ignition_config" "user-data" {
  users = [
    data.ignition_user.cluster_user.id
  ]

  files = [
    data.ignition_file.cluster-init.id
  ]

  systemd = [
    data.ignition_systemd_unit.bootstrap-service.id
  ]
}