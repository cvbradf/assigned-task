
# ====================
# Variables
# ====================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.medium"
}

variable "instance_name" {
  type    = string
  default = "web-server"
}

variable "key_pair_name" {
  description = "Name of the EC2 Key Pair"
  type        = string
  default     = "Rocky8.pem"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for web server and client acess"
  type        = string
  default     = "proven-ground-bucket1"
}

variable "web_server_instance_id" {
 description = "Web Server EC2 Instance ID (optional if creating new role)"
 type        = string
 default     = ""
}

variable "s3_bucket_prefix" {
  description = "S3 bucket prefix/path where Web Server can write"
  type        = string
  default     = "*" # Allows write to entire bucket, change to "logs/*" for specific prefix
}