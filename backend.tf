terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
  backend "s3" {
    bucket         = "s3-remote-backend-internship-maksym"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "dynamodb-state-lock-table-internship-maksym"
  }
}
