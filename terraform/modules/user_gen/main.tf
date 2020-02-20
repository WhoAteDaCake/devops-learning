resource "random_string" "random_username" {
  length = 16
  special = false
}

resource "random_string" "random_password" {
  length = 16
  special = false
}
