resource "docker_image" "nginx" {
  name = "nginxdemos/hello"
  # name = "bitnami/nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.name
  name  = "nginx"

  restart = "always"

  networks_advanced {
    name = docker_network.db_network.name
  }

  ports {
    internal = "80"
    external = "80"
  }
}

