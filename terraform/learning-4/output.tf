output "mongodb" {
  value = {
    "MONGODB_DATABASE" = var.mongodb_database,
    "MONGODB_USERNAME" = module.mongdb_user.username
    "MONGODB_PASSWORD" = module.mongdb_user.password
  }

  description = "Mongodb database details"
}

output "minio" {
  value = {
    "MINIO_BUCKET" = var.minio_bucket,
    "MINIO_ACCESS_KEY" = module.minio_user.username
    "MINIO_SECRET_KEY" = module.minio_user.password
  }

  description = "Mongodb database details"
}