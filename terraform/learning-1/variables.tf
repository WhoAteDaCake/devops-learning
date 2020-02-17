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

variable "machine_types" {
  type = map(string)
  default = {
    "dev" = "f1-micro"
    "test" = "n1-highcpu-32"
    "prod" = "n1-highcpu-32"
  }
}

variable "cidrs" { type = list(string) }