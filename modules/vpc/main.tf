# Base VPC that all subnets and the IGW attach to.
resource "aws_vpc" "devlopment_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    name = var.vpc_name
    env  = var.env_name
  }

}

# Gives public subnets a route to the internet; wired in via public_route_table below.
resource "aws_internet_gateway" "devlopment_igw" {
  vpc_id = aws_vpc.devlopment_vpc.id

  tags = {
    name = "${var.env_name}-igw"
    env  = var.env_name
  }

}

# One subnet per AZ in var.availability_zones, using the matching explicit
# CIDR from var.public_subnet_cidr (one entry per count.index).
resource "aws_subnet" "public_subnet" {
  count = 2

  vpc_id            = aws_vpc.devlopment_vpc.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    name = "${var.env_name}-public-subnet-${count.index}"
    env  = var.env_name
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
    name = "${var.env_name}-private-subnet-${count.index}"
    env  = var.env_name
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
    name = "${var.env_name}-public-route-table"
    env  = var.env_name
  }
}

# No explicit route out (and no route to the IGW), so subnets associated with
# this table stay private. AWS adds the local VPC-CIDR route automatically,
# so no route block is needed here.
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.devlopment_vpc.id

  tags = {
    name = "${var.env_name}-private-route-table"
    env  = var.env_name
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
