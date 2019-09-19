# terraform-esxi-k8s

> Using https://github.com/josenk/terraform-provider-esxi to get a Kubernetes cluster up on ESXi. See examples/

# Getting started

```
module "k8s" {
  source = "github.com/silasb/terraform-esxi-k8s"

  cluster_name = "my-cool-cluster"

  key_file = file("~/.ssh/id_rsa.pub")
  k8s_version = "1.16"

  master_groups = [
    {
      memsize  = "2048"
      numvcpus = "2"
      disk_store = "datastore0"
      ovf_source = "coreos_production_vmware_ova.ova"
      virtual_network = "VM Network"
    }
  ]
}
```

You need `coreos_production_vmware_ova.ova` locally before you can use examples.

```
bash <(curl -s https://raw.githubusercontent.com/silasb/terraform-esxi-k8s/master/get-coreos.sh)
```

## TODOs

- [x] be able to select version of cluster (1.15, 1.16)
- [ ] be able to provision workers
- [ ] be able to provision different workers with different arguments for default user-data scripts
- [ ] be able to provision different workers with different names
- [ ] be able to provision different workers with different user-data scripts