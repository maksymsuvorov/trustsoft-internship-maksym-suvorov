# Creates an AWS Config managed rule to check for a required "Name" tag on EC2 instances
resource "aws_config_config_rule" "required_tags" {
  name = "required-tags-ec2-internship-maksym"

  source {
    owner             = "AWS"
    source_identifier = "REQUIRED_TAGS"
  }

  input_parameters = jsonencode({
    tag1Key = "Name"
  })

  # Apply the rule only to EC2 instances
  scope {
    compliance_resource_types = ["AWS::EC2::Instance"]
  }

  description = "Ensures EC2 instances have required tags: Name"
}

