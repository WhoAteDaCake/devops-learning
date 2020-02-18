
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

  metadata_startup_script = <<SCRIPT
    DEVICE_ID=/disks/by-id/google-${google_compute_disk.vm_disk.name}
    MOUNT_PATH=/datadrive
    sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard $DEVICE_ID
    sudo mkdir -p $MOUNT_PATH
    sudo mount -o discard,defaults $DEVICE_ID $MOUNT_PATH
    sudo chmod a+w $MOUNT_PATH

    # Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh

    # Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    touch /etc/docker/daemon.json
    sudo cat > /etc/docker/daemon.json <<- EOM
      {
        "data-root": "$MOUNT_PATH",
        "storage-driver": "overlay2"
      }
EOM
     sudo systemctl restart docker
  SCRIPT
}