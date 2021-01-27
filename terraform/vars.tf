
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

variable "key_name" {
  description = "The name of a Key Pair that you've created in AWS and have saved on your computer. You will be able to use this Key Pair to SSH to the EC2 instance."
}

variable "key_path" {
  description = "The name of a Key Pair that you've created in AWS and have saved on your computer. You will be able to use this Key Pair to SSH to the EC2 instance."
}

variable "tracking_policy_target_value" {
  type = number
}

variable "health_check_grace_period" {
   type = number
   description = "health_check_grace_period"
}

variable "instance_type" {
   type = string
   description = "health_check_grace_period"
}

variable "wait_for_capacity_timeout" {
   default = "5m"
   description = "wait_for_capacity_timeout"
}

variable "nginx_ami_id" {
	type = string
  description = "Nginx image built from packer"
}

variable "bastion_ami_id" {
  type = string
  description = "Bastion image"
}

variable "bastion_instance_type" {
  type = string
  description = "Bastion host type"
}

