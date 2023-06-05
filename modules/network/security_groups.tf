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