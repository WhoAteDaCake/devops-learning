locals {
  docker_host = "ssh://${var.username}@${var.machine_ip}:22"
}

provider "docker" {
  host = local.docker_host
}

module "mongdb_user" {
  source = "../modules/user_gen"
}

resource "docker_image" "mongodb" {
  name = "bitnami/mongodb:4.1.4-debian-9"
}

# # Create a container
# resource "docker_container" "mongodb" {
#   image = docker_image.mongodb.name
#   name  = "mongodb"

#   env = [
#     "MONGODB_USERNAME=${module.mongdb_user.username}",
#     "MONGODB_PASSWORD=${module.mongdb_user.password}",
#     "MONGODB_DATABASE=${var.mongodb_database}"
#   ]

#   ports {
#     internal = "27017"
#     external = "27017"
#   }

#   upload {
#     file = "./seeds/mongodb/plugins.json"
#     source_hash = true
#   }

#   upload {
#     file = "./seeds/mongodb/workflows.json"
#     source_hash = true
#   }
# }