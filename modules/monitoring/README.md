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
| [aws_autoscaling_policy.scale_in_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.scale_on_requests](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_policy.scale_out_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_autoscaling_schedule.scale_in_time](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.scale_up_time](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_cloudwatch_metric_alarm.ec2_1_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_1_disk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_1_mem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_1_status_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_disk](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_mem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.ec2_2_status_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.scale_in](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.scale_out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_sns_topic.sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_subscription.topic_email_sub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_arn_suffix"></a> [alb\_arn\_suffix](#input\_alb\_arn\_suffix) | n/a | `string` | n/a | yes |
| <a name="input_alb_tg_arn_suffix"></a> [alb\_tg\_arn\_suffix](#input\_alb\_tg\_arn\_suffix) | n/a | `string` | n/a | yes |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | n/a | `string` | n/a | yes |
| <a name="input_email_addresses"></a> [email\_addresses](#input\_email\_addresses) | List of email addresses to subscribe to the SNS alert topic | `list(string)` | n/a | yes |
| <a name="input_instance_ids"></a> [instance\_ids](#input\_instance\_ids) | List of EC2 instance IDs for which to create CloudWatch alarms | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_cpu_alarms"></a> [cloudwatch\_cpu\_alarms](#output\_cloudwatch\_cpu\_alarms) | CloudWatch CPU alarms per EC2 instance |
| <a name="output_cloudwatch_disk_alarms"></a> [cloudwatch\_disk\_alarms](#output\_cloudwatch\_disk\_alarms) | CloudWatch disk usage alarms per EC2 instance |
| <a name="output_cloudwatch_memory_alarms"></a> [cloudwatch\_memory\_alarms](#output\_cloudwatch\_memory\_alarms) | CloudWatch memory usage alarms per EC2 instance |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | SNS Topic ARN used for CloudWatch alarms |
