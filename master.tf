resource "esxi_guest" "kube-masters" {
  guest_name = "${var.cluster_name}-master"
  disk_store = "datastore0"

  count = local.master_group_count

  guest_startup_timeout = 120

  guestinfo = {
    "coreos.config.data.encoding" = "base64"
    "coreos.config.data" = base64encode(data.ignition_config.coreos[count.index].rendered)
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

