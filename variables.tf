variable "worker_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations. See workers_group_defaults for valid keys."
  type        = any
  default     = []
}

variable "workers_group_defaults" {
  description = "Override default values for target groups. See workers_group_defaults_defaults in local.tf for valid keys."
  type        = any
  default     = {}
}

variable "master_groups" {
  description = "A list of maps defining master group configurations to be defined using AWS Launch Configurations. See masters_group_defaults for valid keys."
  type        = any
  default     = []
}

variable "config_output_path" {
  description = "Where to save the Kubectl config file (if `write_kubeconfig = true`). Should end in a forward slash `/` ."
  type        = string
  default     = "./"
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `config_output_path`."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the K8s cluster. Also used as a prefix in names of related resources."
  type        = string
}

variable "kubeconfig_name" {
  description = "Override the default name used for items kubeconfig."
  type        = string
  default     = ""
}

variable "key_file" {
  description = "Key file for all groups"
  type = string
  default = ""
}

variable "k8s_version" {
  description = "Version of k8s, supports (1.14, 1.15, 1.16)"
  type = string
  default = "1.16"
}