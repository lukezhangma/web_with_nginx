resource "aws_launch_configuration" "nginx-launch-config" {
  name            = "nginx-server-launch-config"
  image_id        = var.nginx_ami_id
  instance_type   = var.instance_type
  # Security group
  security_groups =  var.security_groups
  user_data       = file("autoscaling/userdata.sh")
  key_name        = var.key_name
}


resource "aws_autoscaling_group" "sessionm_asg" {

  name                      = "autoscaling-asg"
  max_size                  = 4
  min_size                  = 2
  health_check_type         = "ELB"
  desired_capacity          = 2



  launch_configuration      = aws_launch_configuration.nginx-launch-config.name
  protect_from_scale_in     = false
  vpc_zone_identifier       = var.subnets
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  health_check_grace_period = var.health_check_grace_period
  target_group_arns         = var.autoscaling_targetgroup_arns

  tag {
    key                 = "Name"
    value               = "autosaling"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "web_cluster_target_tracking_policy" {
  name                      = "web-cluster-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.sessionm_asg.name
  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.tracking_policy_target_value
  }
}

resource "aws_autoscaling_policy" "autoscaling_policy" {
   name = "terraform-autoplicy"
   scaling_adjustment = 1
   adjustment_type = "ChangeInCapacity"
   cooldown = 300
   autoscaling_group_name = aws_autoscaling_group.sessionm_asg.name
}

#########
# Outputs
#########
output "nginx_autoscaling_group_name" {
  value = aws_autoscaling_group.sessionm_asg.name
}

output "nginx_autoscaling_policy_arn" {
  value = aws_autoscaling_policy.autoscaling_policy.arn
 }
 