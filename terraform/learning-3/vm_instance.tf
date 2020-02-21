
resource "google_compute_disk" "vm_disk" {
  name  = "test-disk-${random_id.instance_id.hex}"
  type  = "pd-ssd"
  zone  = var.zone

  physical_block_size_bytes = 4096
  size = var.disk_size
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance-${random_id.instance_id.hex}"
  machine_type = var.machine_type
  tags         = ["web", "dev"]

  connection {
    type = "ssh"
    user = var.ssh_user
    host = google_compute_address.vm_static_ip.address
    private_key = file("~/.ssh/id_rsa")
    agent = true
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  network_interface {
    network = google_compute_firewall.network.network
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  attached_disk {
    source = google_compute_disk.vm_disk.self_link
    device_name = google_compute_disk.vm_disk.name
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }

  provisioner "file" {
    source      = "../scripts/mount_device.sh"
    destination = "/tmp/mount_device.sh"
  }

  provisioner "file" {
    source      = "../scripts/docker.sh"
    destination = "/tmp/docker.sh"
  }

  provisioner "file" {
    source      = "../scripts/os_config.sh"
    destination = "/tmp/os_config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "MOUNT_PATH=/datadrive DEVICE_ID=${google_compute_disk.vm_disk.name} bash /tmp/mount_device.sh",
      "MOUNT_PATH=/datadrive bash /tmp/docker.sh",
      "bash /tmp/os_config.sh"
    ]
  }
}

resource "null_resource" "clear_keys" {
  depends_on = [google_compute_disk.vm_disk]

  # Make sure that old ssh key is removed 
  provisioner "local-exec" {
    command = "ssh-keygen -f '/home/augustinas/.ssh/known_hosts' -R '${google_compute_address.vm_static_ip.address}'"
  }
}