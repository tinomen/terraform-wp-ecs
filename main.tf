provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "us-west-2"
}

locals {
    environment = "stage"
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
    security_groups = [module.network.db_security_group_id]
}

module "ecs" {
    source = "./modules/ecs"

    environment             = local.environment
    ecs_subnet_ids          = module.network.public_subnet_ids
    ecs_security_group_ids  = [module.network.ecs_security_group_id]
    efs_file_system_id       = module.network.efs_file_system_id
    efs_access_point_id     = module.network.efs_access_point_id
    db_url                  = module.db.db_url
    db_username             = module.db.rds_username
    db_password             = module.db.rds_password
    http_target_group_arn   = module.network.http_target_group_arn
    cloudwatch_log_name     = module.network.cloudwatch_log_name
    ecs_task_execution_role_arn = module.network.ecs_task_execution_role_arn
}
