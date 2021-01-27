

#################
# VPC and Subnets
#################
resource "aws_vpc" "application_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"

  tags = {
      Name = "Takehome VPC - application_vpc"
      Type = "application_vpc"
    }

}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.application_vpc.id
  cidr_block              = "${var.vpc_subnet_cidr_block_prefix}.1.${var.vpc_subnet_cidr_block_suffix}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}a"

  tags = {
      Name     = "Takehome Application VPC - public_subnet_1"
      Type     = "public_subnet_1"
      Exposure = "public"
      VPC      = "application"
    }

}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.application_vpc.id
  cidr_block              = "${var.vpc_subnet_cidr_block_prefix}.2.${var.vpc_subnet_cidr_block_suffix}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.aws_region}b"

  tags = {
      Name      = "Application VPC - public_subnet_2"
      Type      = "public_subnet_2"
      Exposure  = "public"
      VPC       = "application"

    }
}


resource "aws_subnet" "private_subnet_1" {
  vpc_id                  = aws_vpc.application_vpc.id
  cidr_block              = "${var.vpc_subnet_cidr_block_prefix}.101.${var.vpc_subnet_cidr_block_suffix}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = {
      Name     = "Takehome Application VPC - private_subnet_1"
      Type     = "private_subnet_1"
      Exposure = "private"
      VPC      = "application"

    }
}



################################################
# Inernet Gateway and Routing for Public Subnets
################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
      Name = "Takehome Application VPC - igw"
      Type = "igw"
    }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.application_vpc.id

  tags = {
      Name = "Takehome Application VPC - public_route_table"
      Type = "public_route_table"
    }
}

resource "aws_route" "public_route_internet" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

#########
# Outputs
#########
output "application_vpc_id" {
  value = aws_vpc.application_vpc.id
}

output "vpc_public_subnet_ids" {
  value = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

output "vpc_private_subnet_id" {
  value = aws_subnet.private_subnet_1.id
}


output "vpc_igw" {
  value = aws_internet_gateway.igw.id
}

output "vpc_public_route_table" {
  value = aws_route_table.public_route_table.id
}


