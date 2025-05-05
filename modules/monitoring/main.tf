resource "aws_ssm_parameter" "cw_agent_config" {
  name  = "/cloudwatch-agent/config"
  type  = "String"

  value = jsonencode({
    agent = {
      metrics_collection_interval = 60
      run_as_user                 = "root"
    }
    metrics = {
      namespace = "CWAgent"
      append_dimensions = {
        InstanceId = "$${aws:InstanceId}"
      }
      metrics_collected = {
        mem = {
          measurement = [
            "mem_used_percent"
          ]
        }
        disk = {
          measurement = [
            "disk_used_percent"
          ]
          resources = ["/"]
        }
      }
    }
  })
}

# SSM Document to install and start CloudWatch Agent
resource "aws_ssm_document" "cw_agent_install" {
  name            = "InstallCloudWatchAgent"
  document_type   = "Command"
  document_format = "YAML"

  content = <<DOC
schemaVersion: '2.2'
description: 'Install and configure CloudWatch agent'
parameters:
  action:
    type: String
    description: "Install the CloudWatch agent"
    default: "Install"
  configurationLocation:
    type: String
    description: "SSM parameter name for agent config"
    default: "${aws_ssm_parameter.cw_agent_config.name}"
mainSteps:
  - action: aws:configurePackage
    name: installCWAgent
    inputs:
      name: AmazonCloudWatchAgent
      action: "{{ action }}"
  - action: aws:runShellScript
    name: configureCWAgent
    inputs:
      runCommand:
        - |
          /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
            -a fetch-config -m ec2 \
            -c ssm:{{ configurationLocation }} \
            -s
DOC
}

# SSM Association to run the install on instances tagged with Monitoring=enabled
resource "aws_ssm_association" "cw_agent_association" {
  name = aws_ssm_document.cw_agent_install.name

  targets {
    key    = "tag:Monitoring"
    values = ["enabled"]
  }

  parameters = {
    action                = "Install"
    configurationLocation = aws_ssm_parameter.cw_agent_config.name
  }
}






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
    InstanceId = var.instance_ids[0]
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
  }

  tags = {
    Name = "ec2-2-disk-metric-alarm-internship-maksym"
  }
}
