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

# CloudWatch Alarm for EC2 Instance 2 CPU utilization
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

# CloudWatch Alarm for EC2 Instance 2 CPU utilization
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

# CloudWatch Alarm for EC2 Instance 2 CPU utilization
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

# CloudWatch Alarm for EC2 Instance 2 CPU utilization
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


