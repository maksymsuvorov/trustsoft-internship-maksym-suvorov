resource "aws_sns_topic" "sns-topic" {
  name = "cpu-utilization-alert-internship-maksym"
}

resource "aws_sns_topic_subscription" "topic-email-sub" {
  count = length(var.email_address)
  topic_arn = aws_sns_topic.sns-topic.arn
  protocol = "email"
  endpoint = var.email_address[count.index]
}

resource "aws_cloudwatch_metric_alarm" "ec2-1-cpu" {
  alarm_name          = "ec2-1-cpu-utilization-internship-maksym"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 2.4
  alarm_description   = "This metric monitors EC2-1 CPU utilization"
  treat_missing_data = "notBreaching"
  insufficient_data_actions = []
  alarm_actions = [aws_sns_topic.sns-topic.arn]

  dimensions = {
    InstanceId = aws_instance.ec2-1.id
  }

  tags = {
    Name = "ec2-1-cpu-metric-alarm-internship-maksym"
  }
}

resource "aws_cloudwatch_metric_alarm" "ec2-2-cpu" {
  alarm_name          = "ec2-2-cpu-utilization-internship-maksym"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 2.4
  alarm_description   = "This metric monitors EC2-2 CPU utilization"
  treat_missing_data = "notBreaching"
  insufficient_data_actions = []
  alarm_actions = [aws_sns_topic.sns-topic.arn]

  dimensions = {
    InstanceId = aws_instance.ec2-2.id
  }
}
