variable "machine_ip" {
  type = string
}

variable "username" {
  type = string
}

variable "mongodb_database" {
  type = string
  default = "nanowire"
}

variable "minio_bucket" {
  type = string
  default = "nanowire"
}