resource "aws_db_subnet_group" "default" {
  name       = "wordpress-db-subnet-group"
  description = "RDS default subnet group"
  subnet_ids = var.subnets
}

resource "aws_db_parameter_group" "default" {
  name        = "mariadb-params"
  family      = "mariadb10.6"
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_security_group" "this" {
  name        = "wordpress-db-security-group"  
  vpc_id      = var.vpc_id
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

resource "aws_db_instance" "default" {
# Allocating the storage for database instance.
  allocated_storage    = 20
# Declaring the database engine and engine_version
  engine               = "mariadb"
  engine_version       = "10.6.10"
# Declaring the instance class
  instance_class       = "db.t2.micro"
  db_name              = "wordpress"
# User to connect the database instance 
  username             = "limble"
# Password to connect the database instance 
  password             = "limbletest"
  
  db_subnet_group_name = aws_db_subnet_group.default.name
  parameter_group_name = aws_db_parameter_group.default.name

  vpc_security_group_ids = [aws_security_group.this.id]
  
  # for testing purposes
  publicly_accessible   = true
  skip_final_snapshot    = true
}