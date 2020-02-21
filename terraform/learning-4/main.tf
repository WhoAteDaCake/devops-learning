locals {
  docker_host = "ssh://${var.username}@${var.machine_ip}:22"
}

provider "docker" {
  host = local.docker_host
}

resource "docker_network" "db_network" {
  name = "db_network"
  attachable = true
}