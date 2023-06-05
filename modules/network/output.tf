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