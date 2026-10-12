resource "aws_route_table" "public" {
  vpc_id = aws_vpc.troubleshooting.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }

  tags = {
    Name = "troubleshooting_public_rt"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "public"
  }
}

resource "aws_route_table_association" "public_1a" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public_1a.id
}
resource "aws_route_table_association" "public_1b" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public_1b.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.troubleshooting.id

  route = []

  tags = {
    Name = "troubleshooting_private_rt"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "private"
  }
}

resource "aws_route_table_association" "private_1a" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private_1a.id
}
resource "aws_route_table_association" "private_1b" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private_1b.id
}
