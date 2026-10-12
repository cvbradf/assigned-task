# Data source to created by Packer
data "aws_ami" "apache-ebs-puppet" {
  most_recent = true
  owners      = ["637423641197"] # Rocky Linux official account

  filter {
        name   = "image-id"
        values = ["ami-071a9f18786b99928"] # Replace with your specific AMI ID
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_ami" "ec2-client" {
  most_recent = true

  filter {
        name   = "image-id"
        values = ["ami-06e56cf955c5bd64b"] # Replace with your specific AMI ID
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

