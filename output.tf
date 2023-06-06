output "vpc_id" {
  value = module.network.vpc_id
}
output "cidr_block" {
  value = module.network.cidr_block
}
output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}
output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}
output "bastion_ip" {
  value = module.network.bastion_host_ip
}
output "bastion_dns" {
  value = module.network.bastion_host_dns
}
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.db.rds_hostname
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.db.rds_port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = module.db.rds_username
}
output "load_balancer_ip" {
  description = "Load balancer IP"
  value       = module.network.load_balancer_ip
}