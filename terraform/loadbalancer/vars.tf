# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------


variable "subnets" {
  default=[]
  description = "map of subnets to deploy your infrastructure in, must have as many keys as your server count (default 3), -var 'subnets={\"0\"=\"subnet-12345\",\"1\"=\"subnets-23456\"}' "
}

variable "application_vpc_id" {
  type = string
  description = "ID of the VPC to use"
}

variable "security_groups" {
  default = []
  description = "ID of the VPC to use"
}

variable "health_check_grace_period" {
  type = number
  description = "Time (in seconds) after instance comes into service before checking health."
}

variable "wait_for_capacity_timeout" {
   default = "5m"
   description = "wait_for_capacity_timeout"
}

