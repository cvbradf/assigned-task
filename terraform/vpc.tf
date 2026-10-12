# Get default VPC
data "aws_vpc" "default" {
  default = true
}