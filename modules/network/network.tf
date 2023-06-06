resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "wordpress" {
  name              = "/wordpress/${var.environment}"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.wordpress.arn
}
resource "aws_cloudwatch_log_stream" "wordpress" {
  name           = "/wordpress/${var.environment}"
  log_group_name = aws_cloudwatch_log_group.wordpress.name
}

##########
# Public

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags =  {
    Name = "public-${var.environment}-${data.aws_availability_zones.available.names[count.index]}"
    Environment = var.environment
  }
}

# Routing table for public subnet
## Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.environment}"
  }
}
# Route the public subnet traffic through the IGW
resource "aws_route" "public_igw" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  count      = var.az_count
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "igw-eip-${var.environment}-${data.aws_availability_zones.available.names[count.index]}"
    Environment = "${var.environment}"
  }
}
# NAT gateway for each public subnet
resource "aws_nat_gateway" "nat" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  
  tags = {
    Name        = "nat-gw-${var.environment}-${data.aws_availability_zones.available.names[count.index]}"
    Environment = "${var.environment}"
  }
}

############
# Private

# Create var.az_count # of private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false

  tags = {
    Name = "private-${var.environment}-${data.aws_availability_zones.available.names[count.index]}"
    Environment = var.environment
  }
}
# Routing table for private subnet
resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name        = "route-table-private-${var.environment}-${data.aws_availability_zones.available.names[count.index]}"
    Environment = "${var.environment}"
  }
}
# Explicitly associate the private route tables to the private subnets
# (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}