
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# -------------------------
# VPC 1
# -------------------------
resource "aws_vpc" "vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc-1"
  }
}

resource "aws_subnet" "vpc1_public" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpc1-public-subnet"
  }
}

resource "aws_subnet" "vpc1_private" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "vpc1-private-subnet"
  }
}

resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpc1-igw"
  }
}

resource "aws_route_table" "vpc1_public" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpc1-public-rt"
  }
}

resource "aws_route" "vpc1_public_internet" {
  route_table_id         = aws_route_table.vpc1_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc1_igw.id
}

resource "aws_route_table" "vpc1_private" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpc1-private-rt"
  }
}

resource "aws_route_table_association" "vpc1_public" {
  subnet_id      = aws_subnet.vpc1_public.id
  route_table_id = aws_route_table.vpc1_public.id
}

resource "aws_route_table_association" "vpc1_private" {
  subnet_id      = aws_subnet.vpc1_private.id
  route_table_id = aws_route_table.vpc1_private.id
}

# -------------------------
# VPC 2
# -------------------------
resource "aws_vpc" "vpc2" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc-2"
  }
}

resource "aws_subnet" "vpc2_public" {
  vpc_id                  = aws_vpc.vpc2.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpc2-public-subnet"
  }
}

resource "aws_subnet" "vpc2_private" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "vpc2-private-subnet"
  }
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "vpc2-igw"
  }
}

resource "aws_route_table" "vpc2_public" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "vpc2-public-rt"
  }
}

resource "aws_route" "vpc2_public_internet" {
  route_table_id         = aws_route_table.vpc2_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc2_igw.id
}

resource "aws_route_table" "vpc2_private" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "vpc2-private-rt"
  }
}

resource "aws_route_table_association" "vpc2_public" {
  subnet_id      = aws_subnet.vpc2_public.id
  route_table_id = aws_route_table.vpc2_public.id
}

resource "aws_route_table_association" "vpc2_private" {
  subnet_id      = aws_subnet.vpc2_private.id
  route_table_id = aws_route_table.vpc2_private.id
}

# -------------------------
# Outputs
# -------------------------
output "vpc_ids" {
  description = "IDs of the two VPCs"
  value = {
    vpc1 = aws_vpc.vpc1.id
    vpc2 = aws_vpc.vpc2.id
  }
}

output "subnet_ids" {
  description = "IDs of the four subnets"
  value = {
    vpc1_public  = aws_subnet.vpc1_public.id
    vpc1_private = aws_subnet.vpc1_private.id
    vpc2_public  = aws_subnet.vpc2_public.id
    vpc2_private = aws_subnet.vpc2_private.id
  }
}
