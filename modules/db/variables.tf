variable "environment" {
  description = "The environment name"
  default = "stage"
}
variable "username" {
  description = "The database username"
  default = "wordpress_user"
}
variable "password" {
  description = "The database password"
  default = "wordpress_password"
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}
variable "subnets" {
  description = "List of subnet IDs used by database subnet group created"
  type        = list(string)
  default     = []
}
variable "security_groups" {
  description = "List of security group IDs to be allowed to connect to the database"
  type        = list(string)
  default     = []
}