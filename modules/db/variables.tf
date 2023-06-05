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