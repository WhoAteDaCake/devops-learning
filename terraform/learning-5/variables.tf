variable "project" {
  type = string
}

variable "credentials_file" {
  type = string
}

variable "region" {
  type = string 
  default = "europe-west2"
}

variable "zone" {
  type = string
  default = "europe-west2-c"
}

variable "ip_address" {
  type = string
  description = "Ip address of the machine"
}

variable "domain" {
  type = string
}

