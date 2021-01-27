####################
# Environment basics
####################
aws_region                   = "us-east-1"


###########
# VPC Stuff
###########
vpc_cidr_block               = "10.51.0.0/16"
vpc_subnet_cidr_block_prefix = "10.51"
vpc_subnet_cidr_block_suffix = "0/24"

key_name= "luke-instance"
key_path ="~/.ssh/luke-instance.pem"
instance_type = "t3.micro"

tracking_policy_target_value = 20
health_check_grace_period= 600
wait_for_capacity_timeout = "5m"
nginx_ami_id = "ami-07babf81a5a041f1a"

bastion_ami_id = "ami-07babf81a5a041f1a"
bastion_instance_type = "t3.micro"