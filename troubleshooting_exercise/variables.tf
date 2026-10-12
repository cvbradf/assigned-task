variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "s3_bucket_prefix" {
  type = string
}

variable "my_ip_addr" {
  type = string
  description = "IP address of the machine you'll connect to EC2 instances from"
}

variable "key_pair_name" {
  type = string
  description = "Existing EC2 Keypair to connect to EC2 instances with"
}
