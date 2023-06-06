data "aws_security_group" "default" {
  name   = "default"
  vpc_id = aws_vpc.main.id
}

# Allow SSH access from the bastion host
resource "aws_security_group" "admin_bastion_ssh" {
  name        = "${var.environment}-admin-bastion-ssh-sg"
  description = "limited ssh access to admin bastion"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-admin-bastion-ssh-sg"
    Environment = var.environment
  }
}
resource "aws_security_group_rule" "bastion_ingress" {
  type                     = "ingress"
  description              = "ssh connection from internet"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.admin_bastion_ssh.id
}
resource "aws_security_group_rule" "bastion_egress" {
  type                     = "egress"
  description              = "instance connect to internet"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.admin_bastion_ssh.id
}

# DB SG
resource "aws_security_group" "db" {
  name        = "${var.environment}-wordpress-db-security-group"  
  vpc_id      = aws_vpc.main.id
  description = "Control traffic to/from RDS"
}
resource "aws_security_group_rule" "db_ingress" {
  type                     = "ingress"
  description              = "mysql connection from vpc"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  cidr_blocks              = [aws_vpc.main.cidr_block]
  security_group_id        = aws_security_group.db.id
}
resource "aws_security_group_rule" "db_egress" {
  type                     = "egress"
  description              = "rds instance connect to internet"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.db.id
}

# LB SG
resource "aws_security_group" "lb" {
  name        = "example-alb-security-group"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-wordpress-lb-sg"
    Environment = var.environment
  }
}
resource "aws_security_group_rule" "lb_ingress_http" {
  security_group_id        = aws_security_group.lb.id
  type                     = "ingress"
  description              = "http"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "lb_egress_http" {
  security_group_id        = aws_security_group.lb.id
  type                     = "egress"
  description              = "http"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# EFS SG
resource "aws_security_group" "efs_service" {
  name        = "${var.environment}-wordpress-efs-service"
  description = "wordpress efs service"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-wordpress-efs-service-sg"
    Environment = var.environment
  }
}
resource "aws_security_group_rule" "efs_service_ingress_nfs_tcp" {
  security_group_id        = aws_security_group.efs_service.id
  type                     = "ingress"
  description              = "efs from ecs"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_service.id
}

# ECS SG
resource "aws_security_group" "ecs_service" {
  name        = "${var.environment}-wordpress-ecs-service"
  description = "wordpress ecs service"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-wordpress-ecs-service-sg"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ecs_service_ingress_http" {
  type                     = "ingress"
  description              = "http from load balancer"
  protocol                 = "tcp"
  from_port                = 8080
  to_port                  = 8080
  cidr_blocks              = [aws_vpc.main.cidr_block]
  security_group_id        = aws_security_group.ecs_service.id
}
resource "aws_security_group_rule" "ecs_service_egress" {
  type              = "egress"
  description       = "http to internet"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
}
# resource "aws_security_group_rule" "ecs_service_egress_mysql" {
#   type                     = "egress"
#   description              = "mysql"
#   from_port                = 3306
#   to_port                  = 3306
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.db.id
#   security_group_id        = aws_security_group.ecs_service.id
# }

# resource "aws_security_group_rule" "ecs_service_egress_efs_tcp" {
#   type                     = "egress"
#   description              = "efs"
#   from_port                = 2049
#   to_port                  = 2049
#   protocol                 = "tcp"
#   source_security_group_id = aws_security_group.efs_service.id
#   security_group_id        = aws_security_group.ecs_service.id
# }

resource "aws_security_group" "memcached" {
  name        = "${var.environment}-memcached"
  description = "memcached"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-memcached-sg"
    Environment = var.environment
  }
}
resource "aws_security_group_rule" "memcached_ingress" {
  type                     = "ingress"
  description              = "memcached"
  protocol                 = "tcp"
  from_port                = 11211
  to_port                  = 11211
  cidr_blocks              = [aws_vpc.main.cidr_block]
  security_group_id        = aws_security_group.memcached.id
}
resource "aws_security_group_rule" "memcached_egress" {
  type                     = "egress"
  description              = "memcached"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.memcached.id
}