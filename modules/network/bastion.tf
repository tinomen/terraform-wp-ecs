resource "aws_key_pair" "bastion" {
  key_name   = "${var.environment}-bastion-host-key"
  public_key = file(var.public_key)
}

resource "aws_instance" "admin_bastion" {
  ami                         = "ami-03f65b8614a860c29" # basic ubuntu 22.04 LTS
  instance_type               = "t2.small"
  associate_public_ip_address = true
  disable_api_termination     = false
  monitoring                  = false
  
  key_name               = aws_key_pair.bastion.key_name
  subnet_id              = aws_subnet.public[1].id
  vpc_security_group_ids = [aws_security_group.admin_bastion_ssh.id, data.aws_security_group.default.id]
  
  tags = {
    Name = "admin-bastion-host"
  }
  user_data = base64encode(<<EOF
#!/bin/bash -xe
sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y curl git python3-pip
sudo DEBIAN_FRONTEND=noninteractive -H pip install --upgrade awscli

EOF
)
}