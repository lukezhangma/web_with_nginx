variable "nginx_autoscaling_group_name"{
	type = string
	description ="Autoscaling group name on which alarm to alarm on."
}

variable "nginx_autoscaling_policy_arn"{
	type = string
	description ="Arn of Autoscaling group policy."
}

