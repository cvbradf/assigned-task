resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.troubleshooting.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "troubleshooting_public_1a"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "public"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id = aws_vpc.troubleshooting.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "troubleshooting_public_1b"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "public"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.troubleshooting.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "troubleshooting_private_1a"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "private"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id = aws_vpc.troubleshooting.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "troubleshooting_private_1b"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "private"
  }
}
