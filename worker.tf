resource "esxi_guest" "kube-workers" {
  guest_name = "${terraform.workspace}-kube-workers-${count.index + 1}"
  disk_store = "datastore0"

  count = local.worker_group_count

  boot_disk_size     = lookup(
    var.worker_groups[count.index],
    "boot_disk_size",
    local.workers_group_defaults_defaults["boot_disk_size"]
  )

  #lifecycle {
    #create_before_destroy = true
  #}

  guestinfo = lookup(
    var.worker_groups[count.index],
    "guestinfo",
    {}
  )

  # download the latest ova from coreos site
  # curl -LO https://stable.release.core-os.net/amd64-usr/current/coreos_production_vmware_ova.ova
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
    virtual_network = "VM Network" # Required for each network interface, Specify the Virtual Network name.
  }

  connection {
    host     = "${self.ip_address}"
    type     = "ssh"
    user     = "core"
    private_key = "${file("~/.ssh/id_rsa")}"
    timeout = "45s"
  }

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

