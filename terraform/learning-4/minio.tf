module "minio_user" {
  source = "../modules/user_gen"
}

resource "docker_volume" "minio_volume" {
  name = "minio_volume"
}

resource "docker_image" "minio" {
  name = "minio/minio:RELEASE.2019-03-06T22-47-10Z"
}

resource "docker_container" "minio" {
  image = docker_image.minio.name
  name  = "minio"

  restart = "always"
  command = ["bash", "-c", "\"sudo mkdir -p /data/$MINIO_BUCKET && /usr/bin/docker-entrypoint.sh minio server /data\""]

  env = [
    "MINIO_ACCESS_KEY=${module.minio_user.username}",
    "MINIO_SECRET_KEY=${module.minio_user.password}",
    "MINIO_BUCKET=${var.minio_bucket}"
  ]

  networks_advanced {
    name = docker_network.db_network.name
  }

  ports {
    internal = "9000"
    external = "9000"
  }

  volumes {
    volume_name = docker_volume.minio_volume.name
    container_path = "/data"
  }
}

