resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg"
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = var.subnet_ids
  launch_template {
    id      = var.template_web_server_id
    version = "$Latest"
  }

  target_group_arns = var.lb_target_group_arns

  health_check_type = "EC2"
  force_delete      = true

  tag {
    key                 = "Name"
    value               = "web-asg-instance-internship-maksym"
    propagate_at_launch = true
  }
}

