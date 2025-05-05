## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.81 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.81 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.ec2_1_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_1_disk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_1_mem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_1_status_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_disk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_mem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_status_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.topic_email_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_ssm_association.cw_agent_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.cw_agent_install](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_ssm_parameter.cw_agent_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | List of email addresses to subscribe to the SNS alert topic | `list(string)` | n/a | yes |
| <a name="input_instance_ids"></a> [instance\_ids](#input\_instance\_ids) | List of EC2 instance IDs for which to create CloudWatch alarms | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_cpu_alarms"></a> [cloudwatch\_cpu\_alarms](#output\_cloudwatch\_cpu\_alarms) | CloudWatch CPU alarms per EC2 instance |
| <a name="output_cloudwatch_disk_alarms"></a> [cloudwatch\_disk\_alarms](#output\_cloudwatch\_disk\_alarms) | CloudWatch disk usage alarms per EC2 instance |
| <a name="output_cloudwatch_memory_alarms"></a> [cloudwatch\_memory\_alarms](#output\_cloudwatch\_memory\_alarms) | CloudWatch memory usage alarms per EC2 instance |
| <a name="output_cloudwatch_ssm_association_id"></a> [cloudwatch\_ssm\_association\_id](#output\_cloudwatch\_ssm\_association\_id) | SSM Association ID for CloudWatch Agent deployment |
| <a name="output_cloudwatch_ssm_document_name"></a> [cloudwatch\_ssm\_document\_name](#output\_cloudwatch\_ssm\_document\_name) | SSM document for installing CloudWatch Agent |
| <a name="output_cloudwatch_ssm_parameter_name"></a> [cloudwatch\_ssm\_parameter\_name](#output\_cloudwatch\_ssm\_parameter\_name) | SSM parameter name for CloudWatch Agent config |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | SNS Topic ARN used for CloudWatch alarms |
