###########
# Bastion Stuff
###########
# bation ami
variable "bastion_ami_id" {
  type = string
}

# instance type
variable "bastion_instance_type" {
  type = string
}


variable "key_name" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "vpc_public_subnet_id" {
  type = string
}
