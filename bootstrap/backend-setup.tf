# DynamoDB Table for Terraform state locking
resource "aws_dynamodb_table" "terraform-lock" {
  name           = var.dynamodb_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S" # String type key
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}

# S3 Bucket for storing Terraform state
resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

# KMS Key for encrypting the Terraform state file in S3
resource "aws_kms_key" "state-key" {
  deletion_window_in_days = 10   # Days before deletion if destroyed
  enable_key_rotation     = true # Enables annual key rotation

  tags = {
    Name = "state-kms-key-internship-maksym"
  }
}

# Apply server-side encryption to the S3 bucket using KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "state-encryption" {
  bucket = aws_s3_bucket.s3-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"                 # Use KMS encryption
      kms_master_key_id = aws_kms_key.state-key.arn # Use custom keWhy Amazon Simple Notification Service (SNS)?y
    }
  }
}

# Enable versioning on the S3 bucket to preserve state history
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.s3-bucket.id

  versioning_configuration {
    status = "Enabled" # Enables object versioning
  }
}

