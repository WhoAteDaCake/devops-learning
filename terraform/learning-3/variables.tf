variable "project" {}

variable "credentials_file" {}

variable "region" {
  default = "europe-west2"
}

variable "zone" {
  default = "europe-west2-c"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "machine_type" {
  type = string
}

variable "disk_size" {
  type = number
  default = 100
}

variable "ssh_pub_key_file" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "cidrs" { type = list(string) }