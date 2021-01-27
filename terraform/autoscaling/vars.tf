# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------


variable "key_name" {
  type = string
  description = "The name of a Key Pair that you've created in AWS and have saved on your computer. You will be able to use this Key Pair to SSH to the EC2 instance."
}

variable "key_path" {
  type = string
  description = "The name of a Key Pair that you've created in AWS and have saved on your computer. You will be able to use this Key Pair to SSH to the EC2 instance."
}

variable "name" {
  type = string
	default = "nginx autoscaling"
}


variable "nginx_ami_id" {
  type = string
}

variable "region" {
  default     = "us-east-1"
  description = "The region of AWS, for AMI lookups."
}



variable "instance_type" {
  description = "AWS Instance type, if you change, make sure it is compatible with AMI, not all AMIs allow all instance types "
}

variable "tagName" {
  default     = "autoscaling-web-server"
  description = "Name tag for the servers"
}


variable "subnets" {
  default=[]
  description = "map of subnets to deploy your infrastructure in, must have as many keys as your server count (default 3), -var 'subnets={\"0\"=\"subnet-12345\",\"1\"=\"subnets-23456\"}' "
}

variable "security_groups" {
  type = list
  description = "ID of the VPC to use - in case your account doesn't have default VPC"
}

variable "tracking_policy_target_value" {
   default = "20"
  description = "Autocaling threshold"
}

variable "health_check_grace_period" {
   default = "600"
  description = "Time (in seconds) after instance comes into service before checking health."
}

variable "wait_for_capacity_timeout" {
   default = "5m"
   description = "wait_for_capacity_timeout"
}

variable "autoscaling_targetgroup_arns" {
   type = list
   description = "Target group for load balancer"
}

