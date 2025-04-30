# S3 bucket name used for backend
output "terraform_state_bucket" {
  description = "Name of the S3 bucket storing the Terraform state"
  value       = aws_s3_bucket.s3-bucket.bucket
}

# KMS key ARN used for encrypting the backend
output "kms_key_arn" {
  description = "ARN of the KMS key used for backend encryption"
  value       = aws_kms_key.state-key.arn
}

# DynamoDB table name used for state locking
output "dynamodb_table_name" {
  description = "Name of the DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.terraform-lock.name
}

