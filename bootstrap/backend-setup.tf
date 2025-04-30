resource "aws_dynamodb_table" "terraform-lock" {
  name           = "dynamodb-state-lock-table-internship-maksym"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "s3-remote-backend-internship-maksym"

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_kms_key" "state-key" {
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name = "state-kms-key-internship-maksym"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state-encryption" {
  bucket = aws_s3_bucket.s3-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.state-key.arn
    }
  }
}



resource "aws_s3_bucket_versioning" "bucket_versioning" {  
  bucket = aws_s3_bucket.s3-bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
