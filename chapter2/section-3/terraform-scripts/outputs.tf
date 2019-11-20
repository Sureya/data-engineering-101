output "DB_HOST" {
  value = module.db.this_db_instance_address
  description = "The connection endpoint"
}

output "DB_USER" {
  value = module.db.this_db_instance_username
  description = "The master username for the database"
}

output "DB_PWD" {
  value = var.db_password
  description = "The database password"
}

output "DB_NAME" {
  value = module.db.this_db_instance_name
  description = "The database name"
}

output "EC2_DNS_NAME" {
  value = aws_instance.application-instance.public_dns
}