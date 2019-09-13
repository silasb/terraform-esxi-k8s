output "master_ip" {
  value = [
    "${esxi_guest.kube-masters.*.ip_address}",
  ]
}

output "worker_ips" {
  value = [
    "${esxi_guest.kube-workers.*.ip_address}"
  ]
}

output "hostname" {
  value = [
    "${esxi_guest.kube-masters.*.guest_name}",
    "${esxi_guest.kube-workers.*.guest_name}"
  ]
}