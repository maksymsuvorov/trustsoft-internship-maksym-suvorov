# Define a CloudWatch Agent configuration in SSM Parameter Store
resource "aws_ssm_parameter" "cw_agent_config" {
  name = "/cloudwatch-agent/config"
  type = "String"

  value = jsonencode({
    agent = {
      metrics_collection_interval = 60
      run_as_user                 = "root"
    }
    metrics = {
      namespace = "CWAgent" # Metric namespace in CloudWatch
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

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

# SSM Document to install and start CloudWatch Agent
resource "aws_ssm_document" "cw_agent_install" {
  name            = "InstallCloudWatchAgent"
  document_type   = "Command"
  document_format = "YAML"

  # Installs CloudWatch Agent, used by disk_used_percent, mem_used_percent...
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
