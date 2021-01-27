# Configure the AWS Provider
terraform {
  required_providers {
    aws = "~> 3.25.0"
    archive = "~> 1.2.0"
  }
}

provider "aws" {
  region = "us-east-1"
}


# This top file to integrate  Terraform modules.
module "vpc" {
  # The source field can be a path on your file system or a Git URL (even a versioned one!)
  source = "./vpc"

  aws_region                   = var.aws_region
  vpc_cidr_block               = var.vpc_cidr_block 
  vpc_subnet_cidr_block_prefix = var.vpc_subnet_cidr_block_prefix
  vpc_subnet_cidr_block_suffix = var.vpc_subnet_cidr_block_suffix

}


module "security_group" {
  # The source field can be a path on your file system or a Git URL (even a versioned one!)
  source = "./security_group"

  application_vpc_id = module.vpc.application_vpc_id

}

module "bastion" {
  # The source field can be a path on your file system or a Git URL (even a versioned one!)
  source = "./bastion"

  bastion_ami_id = var.bastion_ami_id 
  bastion_instance_type = var.bastion_instance_type
  key_name = var.key_name
  bastion_sg_id = module.security_group.bastion_sg_id
  vpc_public_subnet_id = module.vpc.vpc_public_subnet_ids.0

}


module "autoscaling" {
  # The source field can be a path on your file system or a Git URL (even a versioned one!)
  source = "./autoscaling"

  # Pass parameters to the module
  nginx_ami_id= var.nginx_ami_id

  key_name = var.key_name
  key_path = var.key_path

  subnets = [module.vpc.vpc_private_subnet_id]
  tracking_policy_target_value = var.tracking_policy_target_value
  health_check_grace_period = var.health_check_grace_period
  security_groups = [module.security_group.nginx_server_sg_id]
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  instance_type = var.instance_type
  autoscaling_targetgroup_arns = module.loadbalancer.autoscaling_targetgroup_arns

}

module "alarm" {
  # The source field can be a path on your file system or a Git URL (even a versioned one!)
  source = "./alarm"

  nginx_autoscaling_group_name = module.autoscaling.nginx_autoscaling_group_name
  nginx_autoscaling_policy_arn = module.autoscaling.nginx_autoscaling_policy_arn
}


module "loadbalancer" {

  source = "./loadbalancer"

  health_check_grace_period = var.health_check_grace_period
  subnets = module.vpc.vpc_public_subnet_ids
  application_vpc_id = module.vpc.application_vpc_id
  security_groups = [module.security_group.load_balancer_sg_id]

}


#terraform {
#  backend "s3" {
    # Be sure to change this bucket name and region to match an S3 Bucket you have already created!
#    bucket = "luke-zhang-management"
#    region = "us-east-1"
#    key    = "modules/terraform.tfstate"
#  }
#}
