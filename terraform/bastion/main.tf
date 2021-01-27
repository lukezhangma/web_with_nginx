resource "aws_instance" "bastion_host" {
  ami                         = var.bastion_ami_id
  instance_type               = var.bastion_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.bastion_sg_id]
  subnet_id                   = var.vpc_public_subnet_id
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
      Type = "bastion_host"
      Name = "EC2 - bastion_host"
    }
}


output "bastion_host_id" {
  value = aws_instance.bastion_host.id
}

output "bastion_host_arn" {
  value = aws_instance.bastion_host.arn
}

output "bastion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}
