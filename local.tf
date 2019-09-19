locals {

  master_group_count                       = length(var.master_groups)
  worker_group_count                       = length(var.worker_groups)
  group_count                              = local.worker_group_count + local.master_group_count

  # node_types = {
  #   "master" = local.master_group_count
  #   "worker" = local.worker_group_count
  # }

  kubeconfig_name     = var.kubeconfig_name == "" ? "k8s_${var.cluster_name}" : var.kubeconfig_name

  workers_group_defaults_defaults = {
    # name                          = "count.index"              # Name of the worker group. Literal count.index will never be used but if name is not set, the count.index interpolation will be used.
    boot_disk_size                  = "30"
    # key_file                        = ""
    esxi_timeout                    = 120 # timeout before we give up on ESXi
  }
}

# variable node_types {
#   type = map(number)
#   default = {
#     "master" = local.master_group_count
#     "worker" = local.worker_group_count
#   }
# }

# locals {
#   expanded_names = {
#     for name, count in local.node_types : name => [
#       # for i in range(count) : format("%s%02d", name, i)
#       for i in range(count) : element(esxi_guest.kube-masters, i.index)
#     ]
#   }
# }

# output "expanded_names" {
#   value = local.expanded_names
# }