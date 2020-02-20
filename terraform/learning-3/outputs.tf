output "vm_ip_address" {
  value = google_compute_address.vm_static_ip.address
  description = "VM ip address"
}

output "vm_disk_name" {
  value = google_compute_disk.vm_disk.name
  description = "VM disk name"
}