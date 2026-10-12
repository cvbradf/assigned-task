resource "aws_security_group" "internet_access" {
  name = "internet_access_sg"
  description = "allow outbound access to internet"
  vpc_id = aws_vpc.troubleshooting.id

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "internet_access_sg"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

resource "aws_security_group" "ssh_access" {
  name = "ssh_access_sg"
  description = "allow inbound SSH traffic"
  vpc_id = aws_vpc.troubleshooting.id

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [ "${var.my_ip_addr}/32" ]
  }

  tags = {
    Name = "ssh_access_sg"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

resource "aws_security_group" "private_ssh_access" {
  name = "private_ssh_access_sg"
  description = "allow inbound SSH traffic to private subnet"
  vpc_id = aws_vpc.troubleshooting.id

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [ "10.0.0.0/23" ]
  }

  tags = {
    Name = "private_ssh_access_sg"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

resource "aws_security_group" "s3_access" {
  name = "s3_access_sg"
  description = "allow outbound access to S3 APIs"
  vpc_id = aws_vpc.troubleshooting.id

  egress {
    protocol = "tcp"
    from_port = 443
    to_port = 443
    prefix_list_ids = [ aws_vpc_endpoint.s3.prefix_list_id ]
  }

  tags = {
    Name = "ssh_access_sg"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}
