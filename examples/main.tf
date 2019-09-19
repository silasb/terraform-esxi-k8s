provider "esxi" {
  version       = "~> 1.5"
  esxi_hostname = var.esxi_hostname
  esxi_hostport = var.esxi_hostport
  esxi_username = var.esxi_username
  esxi_password = var.esxi_password
}

provider "random" {
  version = "~> 2.1"
}

locals {
  cluster_name = "example-k8s-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "k8s" {
  source = "../"

  cluster_name = local.cluster_name

  key_file = file("~/.ssh/id_rsa.pub")
  k8s_version = "1.16" # or "1.15"

  master_groups = [
    {
      memsize  = "2048"
      numvcpus = "2"
      disk_store = "datastore0"
      ovf_source = "coreos_production_vmware_ova.ova"
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