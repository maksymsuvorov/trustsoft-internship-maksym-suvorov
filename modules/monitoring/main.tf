# Create an SNS topic for CPU utilization alerts
resource "aws_sns_topic" "sns_topic" {
  name = "cpu-utilization-alert-internship-maksym"
}

# Subscribe email addresses to the SNS topic
resource "aws_sns_topic_subscription" "topic_email_sub" {
  count     = length(var.email_addresses) # Supports multiple email addresses
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = var.email_addresses[count.index] # Each email will receive alerts
}

# CloudWatch Alarm for EC2 Instance 1 CPU utilization
resource "aws_cloudwatch_metric_alarm" "ec2_1_cpu" {
  alarm_name                = "ec2-1-cpu-utilization-internship-maksym"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2 # Breach must happen twice
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60 # Check every 60 seconds
  statistic                 = "Average"
  threshold                 = 90 # Threshold to trigger alarm (very low for demo/testing)
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []                            # Don’t alert on missing data
  alarm_actions             = [aws_sns_topic.sns_topic.arn] # Send alert to SNS

  dimensions = {
    InstanceId = var.instance_ids[0] # Monitor specific EC2
  }

  tags = {
    Name = "ec2-1-cpu-metric-alarm-internship-maksym"
  }
}

# CloudWatch Alarm for EC2 Instance 2 CPU utilization
resource "aws_cloudwatch_metric_alarm" "ec2_2_cpu" {
  alarm_name                = "ec2-2-cpu-utilization-internship-maksym"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 90
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    InstanceId = var.instance_ids[1]
  }

  tags = {
    Name = "ec2-2-cpu-metric-alarm-internship-maksym"
  }
}

# CloudWatch Alarm for EC2 Instance 1 Mem Used Percent utilization
# Requires installed CloudWatch Agent on the instance
resource "aws_cloudwatch_metric_alarm" "ec2_1_mem" {
  alarm_name                = "ec2-1-mem-utilization-internship-maksym"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 90
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    InstanceId = var.instance_ids[0]
  }

  tags = {
    Name = "ec2-1-mem-metric-alarm-internship-maksym"
  }
}

# CloudWatch Alarm for EC2 Instance 2 Mem Used Percent utilization
# Requires installed CloudWatch Agent on the instance
resource "aws_cloudwatch_metric_alarm" "ec2_2_mem" {
  alarm_name                = "ec2-2-mem-utilization-internship-maksym"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 90
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    InstanceId = var.instance_ids[1]
  }

  tags = {
    Name = "ec2-2-mem-metric-alarm-internship-maksym"
  }
}

# CloudWatch Alarm for EC2 Instance 1 Disk Used Percent utilization
# Requires installed CloudWatch Agent on the instance
resource "aws_cloudwatch_metric_alarm" "ec2_1_disk" {
  alarm_name                = "ec2-1-disk-utilization-internship-maksym"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "disk_used_percent"
  namespace                 = "CWAgent"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 90
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    InstanceId = var.instance_ids[0],
    path       = "/",
    device     = "xvda1",
    fstype     = "xfs"
  }

  tags = {
    Name = "ec2-1-disk-metric-alarm-internship-maksym"
  }
}

# CloudWatch Alarm for EC2 Instance 2 Disk Used Percent utilization
# Requires installed CloudWatch Agent on the instance
resource "aws_cloudwatch_metric_alarm" "ec2_2_disk" {
  alarm_name                = "ec2-2-disk-utilization-internship-maksym"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "disk_used_percent"
  namespace                 = "CWAgent"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 90
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    InstanceId = var.instance_ids[1]
    path       = "/",
    device     = "xvda1",
    fstype     = "xfs"
  }

  tags = {
    Name = "ec2-2-disk-metric-alarm-internship-maksym"
  }
}

# CloudWatch Alarm for EC2 Instance 1 status check
resource "aws_cloudwatch_metric_alarm" "ec2_1_status_check" {
  alarm_name                = "ec2-1-status-check-failed-internship-maksym"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 0
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    InstanceId = var.instance_ids[0]
  }

  tags = {
    Name = "ec2-1-status-check-alarm"
  }
}

# CloudWatch Alarm for EC2 Instance 2 status check
resource "aws_cloudwatch_metric_alarm" "ec2_2_status_check" {
  alarm_name                = "ec2-2-status-check-failed-internship-maksym"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 0
  treat_missing_data        = "notBreaching"
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    InstanceId = var.instance_ids[1]
  }

  tags = {
    Name = "ec2-2-status-check-alarm"
  }
}


# Adds 1 instance when triggered
resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale-out-policy-internship-maksym"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = var.asg_name
}

# Triggers scale-out when CPU > 70% for 2 minutes
resource "aws_cloudwatch_metric_alarm" "scale_out" {
  alarm_name          = "asg-scale-out-internship-maksym"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  treat_missing_data  = "notBreaching"
  alarm_description   = "Scale out if CPU > 70% for 2 minutes"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out_policy.arn]
}

# Removes 1 instance when triggered
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale-in-policy-policy-internship-maksym"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = var.asg_name
}

# Triggers scale-in when CPU < 30% for 2 minutes
resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_name          = "asg-scale-in-internship-maksym"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  treat_missing_data  = "notBreaching"
  alarm_description   = "Scale in if CPU < 30% for 2 minutes"
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in_policy.arn]
}

resource "aws_autoscaling_policy" "scale_on_requests" {
  name                   = "scale-on-request-count-internship-maksym"
  autoscaling_group_name = var.asg_name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.alb_arn_suffix}/${var.alb_tg_arn_suffix}"
    }
    target_value       = 1
    disable_scale_in   = false
  }
}

resource "aws_autoscaling_schedule" "scale_up_time" {
  scheduled_action_name  = "scale-up-utc-intrenship-maksym"
  autoscaling_group_name = var.asg_name

  desired_capacity = 3
  min_size         = 2
  max_size         = 3

  recurrence = "25 10 * * 1-5"  # 12:25 Prague time → 10:25 UTC
}

resource "aws_autoscaling_schedule" "scale_in_time" {
  scheduled_action_name  = "scale-in-utc-intrenship-maksym"
  autoscaling_group_name = var.asg_name

  desired_capacity = 2
  min_size         = 2
  max_size         = 3

  recurrence = "30 10 * * 1-5"  # 12:30 Prague (10:30 UTC)
}