provider "esxi" {
  version       = "~> 1.5"
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

module "k8s" {
  source = "../"

  cluster_name = "my-cluster"

  master_groups = [
    {
      memsize  = "2048"
      numvcpus = "2"
      ovf_source = "coreos_production_vmware_ova.ova"
      key_file = file("~/.ssh/id_rsa.pub")
      virtual_network = "VM Network"
    }
  ]

  worker_groups = [
    # {
    #   memsize  = "2048"
    #   numvcpus = "2"
    #   guestinfo = {
    #     "coreos.config.data.encoding" = "base64"
    #     "coreos.config.data" = "${base64encode(data.ignition_config.coreos.rendered)}"
    #   }
    # }
  ]

}

output "master_ip" {
  value = module.k8s.master_ip
}