provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "us-west-2"
}

locals {
    # use the same key pair for all instances
    public_key_file_name = "${var.private_key_file_name}.pub"
}

module "network" {
    source = "./modules/network"
    
    private_key = var.private_key_file_name
    public_key  = local.public_key_file_name
}

module "db" {
    source = "./modules/db"

    vpc_id  = module.network.vpc_id
    subnets = module.network.private_subnet_ids
}
