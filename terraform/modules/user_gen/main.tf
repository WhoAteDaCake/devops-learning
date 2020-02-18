resource "random_string" "random_username" {
  length = 16
  special = true
  override_special = "/@£$"
}

resource "random_string" "random_password" {
  length = 16
  special = true
  override_special = "/@£$"
}
