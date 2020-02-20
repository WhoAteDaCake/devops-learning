
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

  metadata_startup_script = "ls /tmp > test.txt"

  provisioner "file" {
    source      = "../scripts/mount_device.sh"
    destination = "/tmp/mount_device.sh"
  }

  provisioner "file" {
    source      = "../scripts/docker.sh"
    destination = "/tmp/docker.sh"
  }

#   provisioner "remote-exec" {
#     inline = [
#       "curl -fsSL https://get.docker.com -o get-docker.sh",
#       "sudo sh get-docker.sh",
#       <<EOF
#       cat > docker.cfg <<- EOM
#       {
#         "data-root": "$MOUNT_PATH",
#         "storage-driver": "overlay2"
#       }
# EOM
# EOF
# ,
#     "sudo mv docker.cfg /etc/docker/daemon.json",
#     "sudo systemctl restart docker",
#     "sudo usermod -aG docker $USER"
#     ]
#   }

  # Make sure that old ssh key is removed 
  provisioner "local-exec" {
    command = "ssh-keygen -f '/home/augustinas/.ssh/known_hosts' -R '${google_compute_address.vm_static_ip.address}'"
  }
}