resource "aws_db_subnet_group" "default" {
  name       = "${var.environment}-wordpress-db-subnet-group"
  description = "RDS default subnet group"
  subnet_ids = var.subnets
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.environment}-mariadb-params"
  family      = "mariadb10.6"
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

resource "aws_db_instance" "default" {
  identifier           = "${var.environment}-wordpress-db"  
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

  vpc_security_group_ids = var.security_groups
  
  # for testing purposes
  publicly_accessible   = true
  skip_final_snapshot    = true
}