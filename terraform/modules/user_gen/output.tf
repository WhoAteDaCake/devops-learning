output "username" {
  value = random_string.random_username.result
  description = "Username"
}

output "password" {
  value = random_string.random_password.result
  description = "Password"
}
