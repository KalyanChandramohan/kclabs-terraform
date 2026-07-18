# Base VPC that all subnets and the IGW attach to.
resource "aws_vpc" "devlopment_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"


  tags = {
    Name = "${var.vpc_name}-vpc"
    Env  = var.env_name
  }

}

# Gives public subnets a route to the internet; wired in via public_route_table below.
resource "aws_internet_gateway" "devlopment_igw" {
  vpc_id = aws_vpc.devlopment_vpc.id

  tags = {
    Name = "${var.env_name}-igw"
    Env  = var.env_name
  }

}

# One subnet per AZ in var.availability_zones, using the matching explicit
# CIDR from var.public_subnet_cidr (one entry per count.index).
resource "aws_subnet" "public_subnet" {
  count = 2

  vpc_id                  = aws_vpc.devlopment_vpc.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name}-public-subnet-${count.index}"
    Env  = var.env_name
  }
}

# Same per-AZ, per-index CIDR mapping as public_subnet, but from
# var.private_subnet_cidr and with no route to the IGW.
resource "aws_subnet" "private_subnet" {
  count = 2

  vpc_id            = aws_vpc.devlopment_vpc.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.env_name}-private-subnet-${count.index}"
    Env  = var.env_name
  }
}

# Routes all non-VPC-local traffic (0.0.0.0/0) out through the IGW; associated
# with the public subnets below, making them "public".
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.devlopment_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devlopment_igw.id
  }

  tags = {
    Name = "${var.env_name}-public-route-table"
    Env  = var.env_name
  }
}

# No explicit route out (and no route to the IGW), so subnets associated with
# this table stay private. AWS adds the local VPC-CIDR route automatically,
# so no route block is needed here.
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.devlopment_vpc.id

  tags = {
    Name = "${var.env_name}-private-route-table"
    Env  = var.env_name
  }

}

# Associates each public subnet (by matching index) with the public route table.
resource "aws_route_table_association" "public_route_table_association" {
  count          = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id

}

# Associates each private subnet (by matching index) with the private route table.
resource "aws_route_table_association" "private_route_table_association" {
  count          = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id

}

# Destination for VPC flow logs.
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "/vpc/${var.env_name}-flow-logs"
  retention_in_days = var.flow_log_retention_in_days

  tags = {
    Name = "${var.env_name}-vpc-flow-log-group"
    Env  = var.env_name
  }
}

# Lets the VPC flow log service write into the log group above.
resource "aws_iam_role" "vpc_flow_log" {
  name = "${var.env_name}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.env_name}-vpc-flow-log-role"
    Env  = var.env_name
  }
}

resource "aws_iam_role_policy" "vpc_flow_log" {
  name = "${var.env_name}-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.vpc_flow_log.arn}:*"
      }
    ]
  })
}

resource "aws_flow_log" "devlopment_vpc" {
  vpc_id               = aws_vpc.devlopment_vpc.id
  traffic_type         = var.flow_log_traffic_type
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log.arn
  iam_role_arn         = aws_iam_role.vpc_flow_log.arn

  tags = {
    Name = "${var.env_name}-vpc-flow-log"
    Env  = var.env_name
  }
}


// Security group allowing SSH (22) and HTTP (80) from anywhere
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.devlopment_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_name}-bastion-sg"
    Env  = var.env_name
  }
}
