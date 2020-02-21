module "elastic_user" {
  source = "../modules/user_gen"
}

resource "docker_volume" "elastic_volume" {
  name = "elastic_volume"
}

resource "docker_image" "elastic" {
  name = "docker.elastic.co/elasticsearch/elasticsearch:5.6.13"
}

resource "docker_container" "elastic" {
  image = docker_image.elastic.name
  name  = "elastic"

  restart = "always"

  env = [
    "xpack.security.enabled=false",
    "xpack.monitoring.enabled=false",
    "xpack.ml.enabled=false",
    "xpack.graph.enabled=false",
    "xpack.watcher.enabled=false",
    "ES_JAVA_OPTS=-Xms4g -Xmx4g"
  ]

  networks_advanced {
    name = docker_network.db_network.name
  }

  ports {
    internal = "9200"
    external = "9200"
  }

  volumes {
    volume_name = docker_volume.elastic_volume.name
    container_path = "/usr/share/elasticsearch/data"
  }

  ulimit {
    name = "nofile"
    soft = 65536
    hard = 65536
  }
}

