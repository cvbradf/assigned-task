# Create S3 bucket if it doesn't exist
resource "aws_s3_bucket" "web_server_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

# Create S3 bucket if it doesn't exist
resource "aws_s3_bucket" "ec2_client_bucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
