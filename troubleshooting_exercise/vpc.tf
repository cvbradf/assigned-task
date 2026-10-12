resource "aws_vpc" "troubleshooting" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "troubleshooting"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.troubleshooting.id

  tags = {
    Name = "troubleshooting"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

data "aws_iam_policy_document" "s3_vpce_policy" {
  statement {
    sid = "AllowSpecificBuckets"
    effect = "Allow"
    principals {
      type = "*"
      identifiers = [ "*" ]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.bucket1.arn,
      "${aws_s3_bucket.bucket1.arn}/*",
    ]
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.troubleshooting.id
  service_name = "com.amazonaws.${var.aws_region}.s3"
  policy = data.aws_iam_policy_document.s3_vpce_policy.json
  route_table_ids = [
   aws_route_table.public.id,
  ]

  tags = {
    Name = "troubleshooting_s3_vpce"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}
