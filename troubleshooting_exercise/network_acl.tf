resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.troubleshooting.id

  subnet_ids = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id,
  ]

  ingress {
    rule_no = 100
    action = "allow"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    rule_no = 900
    action = "allow"
    protocol = "tcp"
    from_port = 32768
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }
  ingress {
    rule_no = 910
    action = "allow"
    protocol = "udp"
    from_port = 32768
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }

  egress {
    rule_no = 10
    action = "allow"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }
  egress {
    rule_no = 20
    action = "allow"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }
  egress {
    rule_no = 900
    action = "allow"
    protocol = "tcp"
    from_port = 32768
    to_port = 65535
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "troubleshooting_public_nacl"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "public"
  }
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.troubleshooting.id

  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1b.id,
  ]

  ingress {
    rule_no = 100
    action = "allow"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_block = "10.0.0.0/23"
  }

  egress {
    rule_no = 900
    action = "allow"
    protocol = "tcp"
    from_port = 32768
    to_port = 65535
    cidr_block = "10.0.0.0/23"
  }

  tags = {
    Name = "troubleshooting_private_nacl"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "private"
  }
}
