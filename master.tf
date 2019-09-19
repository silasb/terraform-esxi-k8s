module "user-data-master" {
  source = "./user-data"

  type = "master"
  key_file = var.key_file

  k8s_version = var.k8s_version
}

resource "esxi_guest" "kube-masters" {
  guest_name = "${var.cluster_name}-master"
  disk_store = lookup(
    var.master_groups[count.index],
    "disk_store"
  )

  count = local.master_group_count

  guest_startup_timeout = lookup(
    var.master_groups[count.index],
    "esxi_timeout",
    local.workers_group_defaults_defaults.esxi_timeout
  )

  guestinfo = {
    "coreos.config.data.encoding" = "base64"
    "coreos.config.data" = base64encode(
      module.user-data-master.user-data
    )
  }

  # download the latest ova from coreos site
  # curl -LO https://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova
  ovf_source = lookup(
    var.master_groups[count.index],
    "ovf_source"
  )

  power = "on"

  memsize  = lookup(
    var.master_groups[count.index],
    "memsize"
  )

  numvcpus = lookup(
    var.master_groups[count.index],
    "numvcpus"
  )

  network_interfaces {
    virtual_network = lookup(
      var.master_groups[count.index],
      "virtual_network"
    )
  }

  provisioner "local-exec" {
    command = "while ! curl -k https://${self.ip_address}:6443; do sleep 10; done"
  }

  # connection {
  #   host     = self.ip_address
  #   type     = "ssh"
  #   user     = "core"
  #   private_key = file("~/.ssh/id_rsa")
  #   timeout = "120s"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/cluster-init.sh",
  #     "sudo su -c \"/tmp/cluster-init.sh master\"",
  #   ]
  # }
}

