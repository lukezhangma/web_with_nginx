resource "aws_cloudwatch_metric_alarm" "cpu_alarm"{
   alarm_name          = "terraform-alarm"
   comparison_operator = "GreaterThanOrEqualToThreshold"
   evaluation_periods  = "2"
   metric_name         = "CPUUtilization"
   namespace           = "AWS/EC2"
   period              = "120"
   statistic           = "Average"
   threshold           = "60"

   dimensions = {
     AutoScalingGroupName = var.nginx_autoscaling_group_name
   }

   alarm_description = "This metric monitor EC2 instance cpu utilization"
   alarm_actions     = [var.nginx_autoscaling_policy_arn]
}
