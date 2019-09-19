# terraform-esxi-k8s

> WIP currently only master nodes works with CoreOS, no other distros work. See examples/

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