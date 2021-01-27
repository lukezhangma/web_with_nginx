resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.autoscaling_elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.autoscaling-targetgroup.arn
    type             = "forward"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_lb" "autoscaling_elb" {
    name = "autoscaling-elb"

    security_groups = var.security_groups
    subnets = var.subnets
    load_balancer_type = "application"

    idle_timeout = 400

    tags = {
         Name = "autoscaling-elb"
    }
}

resource "aws_lb_target_group" "autoscaling-targetgroup" {
  name        = "autoscaling-targetgroup"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.application_vpc_id
  target_type = "instance"

  health_check {
    interval            = 30
    path                = "/index.html"
    port                = 80
    healthy_threshold   = 6
    unhealthy_threshold = 6
    timeout             = 5
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}


output "autoscaling_elb_dns_name" {
    value = aws_lb.autoscaling_elb.dns_name
}

output "autoscaling_targetgroup_arns" {
  value = [aws_lb_target_group.autoscaling-targetgroup.arn]
}