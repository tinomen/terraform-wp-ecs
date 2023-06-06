data "aws_security_group" "default" {
  name   = "default"
  vpc_id = aws_vpc.main.id
}

# Allow SSH access from the bastion host
resource "aws_security_group" "admin_bastion_ssh" {
  name        = "${var.environment}-admin-bastion-ssh-sg"
  description = "limited ssh access to admin bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.environment}-admin-bastion-ssh-sg"
    Environment = var.environment
  }
}

# DB SG
resource "aws_security_group" "db" {
  name        = "${var.environment}-wordpress-db-security-group"  
  vpc_id      = aws_vpc.main.id
  description = "Control traffic to/from RDS"
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# LB SG
resource "aws_security_group" "lb" {
  name        = "example-alb-security-group"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EFS SG
resource "aws_security_group" "efs_service" {
  name        = "${var.environment}-wordpress-efs-service"
  description = "wordpress efs service"
  vpc_id      = aws_vpc.main.id
}
resource "aws_security_group_rule" "efs_service_ingress_nfs_tcp" {
  security_group_id        = aws_security_group.efs_service.id
  type                     = "ingress"
  description              = "nfs from efs"
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
}

resource "aws_security_group_rule" "ecs_service_ingress_http" {
  type                     = "ingress"
  description              = "http from load balancer"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lb.id
  security_group_id        = aws_security_group.ecs_service.id
}
resource "aws_security_group_rule" "ecs_service_egress_http" {
  type              = "egress"
  description       = "http to internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs_service.id
}
resource "aws_security_group_rule" "ecs_service_egress_mysql" {
  type                     = "egress"
  description              = "mysql"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.db.id
  security_group_id        = aws_security_group.ecs_service.id
}

resource "aws_security_group_rule" "ecs_service_egress_efs_tcp" {
  type                     = "egress"
  description              = "efs"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs_service.id
  security_group_id        = aws_security_group.ecs_service.id
}