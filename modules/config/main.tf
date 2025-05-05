resource "aws_config_config_rule" "required_tags" {
  name = "required-tags-ec2-internship-maksym"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = jsonencode({
    tag1Key = "Name"
  })

  scope {
    compliance_resource_types = ["AWS::EC2::Instance"]
  }

  description = "Ensures EC2 instances have required tags: Name"
}

