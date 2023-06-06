output "vpc_id" {
  value = aws_vpc.main.id
}
output "cidr_block" {
  value = aws_vpc.main.cidr_block
}
output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}
output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}
output "bastion_host_ip" {
  value = aws_instance.admin_bastion.public_ip
}
output "bastion_host_dns" {
  value = aws_instance.admin_bastion.public_dns
}
output "load_balancer_ip" {
  value = aws_lb.wp.dns_name
}
output "db_security_group_id" {
  value = aws_security_group.db.id
}
output "efs_file_system_id" {
  value = aws_efs_file_system.wordpress.id
}
output "efs_access_point_id" {
  value = aws_efs_access_point.wordpress_root.id
}
output "ecs_security_group_id" {
  value = aws_security_group.ecs_service.id
}
output "http_target_group_arn" {
  value = aws_lb_target_group.wp.arn
}
output "cloudwatch_log_name" {
  value = aws_cloudwatch_log_group.wordpress.name
}
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}
