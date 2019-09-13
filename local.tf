locals {

  worker_group_count                       = length(var.worker_groups)
  master_group_count                       = length(var.master_groups)

  kubeconfig_name     = var.kubeconfig_name == "" ? "k8s_${var.cluster_name}" : var.kubeconfig_name

  workers_group_defaults_defaults = {
    # name                          = "count.index"              # Name of the worker group. Literal count.index will never be used but if name is not set, the count.index interpolation will be used.
    boot_disk_size                  = "30"
    key_file                        = ""
    esxi_timeout                    = 120 # timeout before we give up on ESXi
  }
}