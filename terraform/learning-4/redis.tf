module "redis_user" {
  source = "../modules/user_gen"
}

resource "docker_volume" "redis_volume" {
  name = "redis_volume"
}

resource "docker_image" "redis" {
  name = "bitnami/redis:4.0-debian-9"
}

resource "docker_container" "redis" {
  image = docker_image.redis.name
  name  = "redis"

  restart = "always"

  env = [
    "REDIS_PASSWORD=${module.redis_user.password}"
  ]

  networks_advanced {
    name = docker_network.db_network.name
  }

  ports {
    internal = "6379"
    external = "6379"
  }

  volumes {
    volume_name = docker_volume.redis_volume.name
    container_path = "/bitnami/redis/data"
  }
}

