module "user-data-worker" {
  source = "./user-data"

  type = "worker"
  key_file = var.key_file

  k8s_version = var.k8s_version
}

resource "esxi_guest" "kube-workers" {
  depends_on = [esxi_guest.kube-masters]

  guest_name = "${var.cluster_name}-workers-${count.index + 1}"
  disk_store = lookup(
    var.master_groups[count.index],
    "disk_store"
  )

  count = local.worker_group_count

  guest_startup_timeout = lookup(
    var.master_groups[count.index],
    "esxi_timeout",
    local.workers_group_defaults_defaults.esxi_timeout
  )

  boot_disk_size     = lookup(
    var.worker_groups[count.index],
    "boot_disk_size",
    local.workers_group_defaults_defaults["boot_disk_size"]
  )

  guestinfo = {
    "coreos.config.data.encoding" = "base64"
    "coreos.config.data" = base64encode(module.user-data-worker.user-data)
  }

  ovf_source = lookup(
    var.master_groups[count.index],
    "ovf_source"
  )

  power = "on"

  memsize  = lookup(
    var.worker_groups[count.index],
    "memsize"
  )

  numvcpus = lookup(
    var.worker_groups[count.index],
    "numvcpus"
  )

  network_interfaces {
    virtual_network = lookup(
      var.master_groups[count.index],
      "virtual_network"
    )
  }

  # provisioner "local-exec" {
  #   command = "while ! curl -k https://${self.ip_address}:6443; do sleep 1; done"
  # }

  #provisioner "local-exec" {
    #command = "check_health.sh ${self.ip_address}"
  #}

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/cluster-init.sh",
  #     "sudo su -c \"/tmp/cluster-init.sh worker ${esxi_guest.kube-masters[0].ip_address} ${data.external.kube-token.result.token} ${data.external.kube-token.result.ca_cert_sha}\"",
  #   ]
  # }

  # provisioner "remote-exec" {
  #   connection {
  #     host     = "${esxi_guest.kube-masters[0].ip_address}"
  #     type     = "ssh"
  #     user     = "core"
  #     private_key = "${file("~/.ssh/id_rsa")}"
  #     timeout = "45s"
  #   }

  #   inline = [
  #     "/opt/bin/kubectl label node ${self.guest_name} node-role.kubernetes.io/worker=worker"
  #   ]
  # }

  # provisioner "remote-exec" {
  #   connection {
  #     host     = "${esxi_guest.kube-masters[0].ip_address}"
  #     type     = "ssh"
  #     user     = "core"
  #     private_key = "${file("~/.ssh/id_rsa")}"
  #     timeout = "45s"
  #   }

  #   when = "destroy"

    # still doesn't work
    #inline = [
      #"/opt/bin/kubectl drain ${self.guest_name} && sleep 60 && /opt/bin/kubectl delete --ignore-daemonsets ${self.guest_name}"
    #]
  # }
}

