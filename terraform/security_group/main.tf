resource "aws_security_group" "load_balancer_sg" {
  name                   = "load_balancer_sg"
  description            = "Load balancer security group"
  vpc_id                 = var.application_vpc_id
  revoke_rules_on_delete = true

  tags = {
      Name  = "Application SG - load_balancer_sg"
      Type  = "load_balancer_sg"
  }

  # Egress to the outside world
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "allow_ingress_http" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id        = aws_security_group.load_balancer_sg.id
  description              = "Allow HTTP from world"
}


resource "aws_security_group" "nginx_server_sg" {
  name                   = "nginx_server_sg"
  description            = "Application nginx security group"
  vpc_id                 = var.application_vpc_id
  revoke_rules_on_delete = true

  tags ={
      Name = "Application SG - nginx_server_sg"
      Type = "application_database_sg"
  }

  # Egress to anywhere
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_http_from_lb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nginx_server_sg.id
  source_security_group_id = aws_security_group.load_balancer_sg.id
  description              = "Allow HTTP from loadbalancer"
}


# Port 22 Ingress from bastion
resource "aws_security_group_rule" "nginx_server_443_from_lb" {
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nginx_server_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
  description              = "Allow ssh on port 22 to requests from bastion"
}

resource "aws_security_group" "bastion_sg" {
  name                   = "bastion_sg"
  description            = "Security group assigned  bastion"
  vpc_id                 = var.application_vpc_id
  revoke_rules_on_delete = true

  tags ={
      Name = "Application SG - nginx_server_sg"
      Type = "application_database_sg"
  }

  # Egress to anywhere
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Port 22 Ingress from world
resource "aws_security_group_rule" "bastion_22_from_internet" {
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion_sg.id
  cidr_blocks = ["0.0.0.0/0"]
  description              = "Allow ssh on port 22 to requests from internet"
}

#########
# Outputs
#########
output "load_balancer_sg_id" {
  value = aws_security_group.load_balancer_sg.id
}

output "nginx_server_sg_id" {
  value = aws_security_group.nginx_server_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}
