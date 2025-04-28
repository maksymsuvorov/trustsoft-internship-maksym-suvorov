resource "aws_s3_bucket" "bucket" {
  bucket = "s3-remote-backend-internship-maksym"
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}