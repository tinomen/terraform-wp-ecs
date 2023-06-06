output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.default.address
}
output "db_url" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.default.endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.default.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.default.username
}
output "rds_password" {
  description = "RDS instance root password"
  value       = aws_db_instance.default.password
  sensitive   = true
}