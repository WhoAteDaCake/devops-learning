output "docker_host" {
  value = local.docker_host
}

# output "mongodb" {
#   value = {
#     "database" = var.mongodb_database,
#     "username" = module.mongdb_user.username
#     "password" = module.mongdb_user.password
#   }

#   description = "Mongodb database details"
# }