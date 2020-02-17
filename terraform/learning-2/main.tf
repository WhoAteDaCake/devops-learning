provider "random" {}

resource "random_id" "instance_id" {
  byte_length = 4
}

provider "google" {
  credentials = file(var.credentials_file)
  region  = var.region
  zone    = var.zone
  project = var.project

  batching {
    enable_batching = false   
  }
}

module "project_services" {
  source  = "../modules/services"
  project = var.project
}

resource "google_compute_address" "vm_static_ip" {
  name = "terraform-static-ip-${random_id.instance_id.hex}"
  depends_on = [module.project_services]
}

resource "google_compute_network" "network" {
  name                    = "ep-network-${random_id.instance_id.hex}"
  auto_create_subnetworks = "true"
  project                 = var.project
  depends_on = [module.project_services]
}

# Allow the hosted network to be hit over ICMP, SSH, and HTTP.
resource "google_compute_firewall" "network" {
  name    = "allow-ssh-and-tcp-${random_id.instance_id.hex}"
  network = google_compute_network.network.self_link
  project = google_compute_network.network.project

  allow {
    protocol = "tcp"
    ports    = ["22","80"]
  }

  source_ranges = var.cidrs
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
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

  metadata_startup_script = file("../scripts/nginx.sh")
}