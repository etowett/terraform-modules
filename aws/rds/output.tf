output "db-secret-arn" {
  value = aws_secretsmanager_secret_version.rds_default_user_credentials.arn
}

output "db-instance-id" {
  value = module.rds.this_db_instance_id
}

output "db-instance-address" {
  value = module.rds.db_instance_address
}

output "db-instance-endpoint" {
  value = module.rds.db_instance_endpoint
}

output "db-instance-name" {
  value = module.rds.db_instance_name
}

output "db-instance-option-group-arn" {
  value = module.rds.db_option_group_arn
}
