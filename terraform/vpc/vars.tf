####################
# Environment basics
####################

# AWS Region
variable "aws_region" {
  type    = string
  default = "us-east-1"
}


###########
# VPC Stuff
###########
# VPC CIDR block
variable "vpc_cidr_block" {
  type = string
}

# VPC Subnet CIDR block prefix
variable "vpc_subnet_cidr_block_prefix" {
  type = string
}

# VPC Subnet CIDR block suffix
variable "vpc_subnet_cidr_block_suffix" {
  type = string
}


