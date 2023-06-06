variable "environment" {
  description = "The environment name"
  type        = string
  default     = "stage"
}
variable "efs_file_system_id" {
  description = "The EFS id"
  type        = string
}
variable "efs_access_point_id" {
  description = "The EFS access point id"
  type        = string
}
variable "db_url" {
  description = "The database url"
  type        = string
}
variable "db_username" {
  description = "The database username"
  type        = string
}
variable "db_password" {
  description = "The database password"
  type        = string
}
variable "ecs_subnet_ids" {
  description = "The ECS subnet ids"
  type        = list(string)
}
variable "ecs_security_group_ids" {
  description = "The ECS security group ids"
  type        = list(string)
}
variable "http_target_group_arn" {
  description = "The target group arn"
  type        = string
}
variable "cloudwatch_log_name" {
  description = "The cloudwatch log group name"
  type        = string
}
variable "ecs_task_execution_role_arn" {
  description = "The ECS task execution role arn"
  type        = string
}