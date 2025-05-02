# Name of the DynamoDB table to create for state locking
variable "dynamodb_name" {
  type    = string
  default = "dynamodb-state-lock-table-internship-maksym"
}

# Name of the S3 bucket to create for storing Terraform state
variable "bucket_name" {
  type    = string
  default = "s3-remote-backend-internship-maksym"
}