variable "environment" {
  description = "The environment name"
  default = "stage"
}
variable "cidr_block" {
  description = "CIDR IP block to use for VPC (ip/16)"
  default = "10.1.0.0/16"
}
variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}
variable "private_key" {
  description = "Path to private key used for SSH access"
  default = "./my_key"
}
variable "public_key" {
  description = "Path to public key used for SSH access"
  default = "./my_key.pub"
}