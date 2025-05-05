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
| [aws_ssm_association.cw_agent_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_document.cw_agent_install](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |
| [aws_ssm_parameter.cw_agent_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_ssm_association_id"></a> [cloudwatch\_ssm\_association\_id](#output\_cloudwatch\_ssm\_association\_id) | SSM Association ID for CloudWatch Agent deployment |
| <a name="output_cloudwatch_ssm_document_name"></a> [cloudwatch\_ssm\_document\_name](#output\_cloudwatch\_ssm\_document\_name) | SSM document for installing CloudWatch Agent |
| <a name="output_cloudwatch_ssm_parameter_name"></a> [cloudwatch\_ssm\_parameter\_name](#output\_cloudwatch\_ssm\_parameter\_name) | SSM parameter name for CloudWatch Agent config |
