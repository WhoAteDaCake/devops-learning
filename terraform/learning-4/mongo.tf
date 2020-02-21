module "mongdb_user" {
  source = "../modules/user_gen"
}

resource "docker_image" "mongodb" {
  name = "bitnami/mongodb:4.1.4-debian-9"
}

resource "docker_container" "mongodb" {
  image = docker_image.mongodb.name
  name  = "mongodb"

  restart = "always"

  env = [
    "MONGODB_USERNAME=${module.mongdb_user.username}",
    "MONGODB_PASSWORD=${module.mongdb_user.password}",
    "MONGODB_DATABASE=${var.mongodb_database}"
  ]

  networks_advanced {
    name = docker_network.db_network.name
  }

  ports {
    internal = "27017"
    external = "27017"
  }
}