# Create an SNS topic for CPU utilization alerts
resource "aws_sns_topic" "sns-topic" {
  name = "cpu-utilization-alert-internship-maksym"
}

# Subscribe email addresses to the SNS topic
resource "aws_sns_topic_subscription" "topic-email-sub" {
  count      = length(var.email_address)       # Supports multiple email addresses
  topic_arn  = aws_sns_topic.sns-topic.arn
  protocol   = "email"
  endpoint   = var.email_address[count.index]  # Each email will receive alerts
}

# CloudWatch Alarm for EC2 Instance 1 CPU utilization
resource "aws_cloudwatch_metric_alarm" "ec2-1-cpu" {
  alarm_name          = "ec2-1-cpu-utilization-internship-maksym"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2                        # Breach must happen twice
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60                       # Check every 60 seconds
  statistic           = "Average"
  threshold           = 2.4                      # Threshold to trigger alarm (very low for demo/testing)
  treat_missing_data  = "notBreaching"
  insufficient_data_actions = []                 # Don’t alert on missing data
  alarm_actions       = [aws_sns_topic.sns-topic.arn]  # Send alert to SNS

  dimensions = {
    InstanceId = aws_instance.ec2-1.id           # Monitor specific EC2
  }

  tags = {
    Name = "ec2-1-cpu-metric-alarm-internship-maksym"
  }
}

# CloudWatch Alarm for EC2 Instance 2 CPU utilization
resource "aws_cloudwatch_metric_alarm" "ec2-2-cpu" {
  alarm_name          = "ec2-2-cpu-utilization-internship-maksym"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 2.4
  treat_missing_data  = "notBreaching"
  insufficient_data_actions = []
  alarm_actions       = [aws_sns_topic.sns-topic.arn]

  dimensions = {
    InstanceId = aws_instance.ec2-2.id
  }

  tags = {
    Name = "ec2-2-cpu-metric-alarm-internship-maksym"
  }
}

