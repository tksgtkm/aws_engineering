resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-piblic-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[0]
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-piblic-subnet-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "redshift" {
  name        = "${var.project_name}-redshift-sg"
  description = "Redshift Serverless aceess restricted to local IP"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-redshift-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "redshift_from_local" {
  security_group_id = aws_security_group.redshift.id

  description = "Redshift access from local PC"
  ip_protocol = "tcp"
  from_port   = 5439
  to_port     = 5439
  cidr_ipv4   = var.allowed_cidr_ip
}

resource "aws_vpc_security_group_egress_rule" "redshift_all_ipv4" {
  security_group_id = aws_security_group.redshift.id

  description = "Allow all outbound IPv4 traffic"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}