terraform {
  # Specify required providers and versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.81.0"
    }
  }

  # Configure remote backend to store Terraform state securely
  backend "s3" {
    # Name of the S3 bucket that stores the Terraform state file
    bucket = "s3-remote-backend-internship-maksym"

    # Path to the state file within the bucket
    key    = "terraform.tfstate"

    # AWS region where the S3 bucket and DynamoDB table are located
    region = "eu-west-1"

    # DynamoDB table used to enable state locking to prevent concurrent changes
    dynamodb_table = "dynamodb-state-lock-table-internship-maksym"
  }
}

