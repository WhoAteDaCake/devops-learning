output "vm_ip_address" {
  value = google_compute_address.vm_static_ip.address
  description = "VM ip address"
}