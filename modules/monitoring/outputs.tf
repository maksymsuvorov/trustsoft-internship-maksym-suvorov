output "cloudwatch_memory_alarms" {
  description = "CloudWatch memory usage alarms per EC2 instance"
  value = {
    ec2_1 = aws_cloudwatch_metric_alarm.ec2_1_mem.alarm_name
    ec2_2 = aws_cloudwatch_metric_alarm.ec2_2_mem.alarm_name
  }
}

output "cloudwatch_disk_alarms" {
  description = "CloudWatch disk usage alarms per EC2 instance"
  value = {
    ec2_1 = aws_cloudwatch_metric_alarm.ec2_1_disk.alarm_name
    ec2_2 = aws_cloudwatch_metric_alarm.ec2_2_disk.alarm_name
  }
}

output "sns_topic_arn" {
  description = "SNS Topic ARN used for CloudWatch alarms"
  value       = aws_sns_topic.sns_topic.arn
}

output "cloudwatch_cpu_alarms" {
  description = "CloudWatch CPU alarms per EC2 instance"
  value = {
    ec2_1 = aws_cloudwatch_metric_alarm.ec2_1_cpu.alarm_name
    ec2_2 = aws_cloudwatch_metric_alarm.ec2_2_cpu.alarm_name
  }
}
