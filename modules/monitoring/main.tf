locals {
  # Define the metrics you want alarms for
  metrics = {
    cpu = {
      namespace       = "AWS/EC2"
      metric_name     = "CPUUtilization"
      threshold       = 90
      period          = 60
      statistic       = "Average"
      treat_missing   = "notBreaching"
      dimension_key   = "InstanceId"
    }
    memory = {
      namespace       = "Maksym"
      metric_name     = "mem_used_percent"
      threshold       = 90
      period          = 60
      statistic       = "Average"
      treat_missing   = "notBreaching"
      dimension_key   = "InstanceId"
    }
    disk = {
      namespace       = "Maksym"
      metric_name     = "disk_used_percent"
      threshold       = 90
      period          = 60
      statistic       = "Average"
      treat_missing   = "notBreaching"
      dimension_key   = "InstanceId"
    }
  }

  # Create a flat list of { instance_id, metric, config } objects
  instance_metric_pairs = flatten([
    for inst in var.instance_ids : [
      for met, cfg in local.metrics : {
        instance_id = inst
        metric      = met
        config      = cfg
      }
    ]
  ])

  # Convert that list into a map suitable for for_each
  alarm_map = {
    for pair in local.instance_metric_pairs :
    "${pair.instance_id}-${pair.metric}" => pair
  }
}

resource "aws_ssm_parameter" "cw_agent_config" {
  name  = "/cloudwatch-agent/config"
  type  = "String"

  value = jsonencode({
    agent = {
      metrics_collection_interval = 60
      run_as_user                 = "root"
    }
    metrics = {
      namespace = "Maksym"
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

# Single resource block to create all alarms
resource "aws_cloudwatch_metric_alarm" "utilization" {
  for_each = local.alarm_map

  alarm_name          = "ec2-${each.key}-internship-maksym"
  namespace           = each.value.config.namespace
  metric_name         = each.value.config.metric_name
  statistic           = each.value.config.statistic
  period              = each.value.config.period
  evaluation_periods  = 2
  threshold           = each.value.config.threshold
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = each.value.config.treat_missing
  alarm_actions       = [aws_sns_topic.sns_topic.arn]

  dimensions = {
    (each.value.config.dimension_key) = each.value.instance_id
  }

  tags = {
    Name = "ec2-${each.key}-internship-maksym"
  }
}

