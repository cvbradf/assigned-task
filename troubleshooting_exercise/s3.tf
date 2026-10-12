data "aws_iam_policy_document" "bucket1_policy" {
  statement {
    sid = "AllowSSLRequestsOnly"
    effect = "Deny"
    principals {
      type = "*"
      identifiers = [ "*" ]
    }
    actions = [ "s3:*" ]
    resources = [
      aws_s3_bucket.bucket1.arn,
      "${aws_s3_bucket.bucket1.arn}/*"
    ]
    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = [ "false" ]
    }
  }

  statement {
    sid = "AllowRoleAccess"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.alpha_instance.arn,
        aws_iam_role.omega_instance.arn,
      ]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.bucket1.arn,
      "${aws_s3_bucket.bucket1.arn}/*"
    ]
  }
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "${var.s3_bucket_prefix}-proving-ground-troubleshooting-bucket1"
  acl = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "bucket1"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket1" {
  bucket = aws_s3_bucket.bucket1.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "bucket1_policy" {
  bucket = aws_s3_bucket.bucket1.id
  policy = data.aws_iam_policy_document.bucket1_policy.json
}

data "aws_iam_policy_document" "bucket2_policy" {
  statement {
    sid = "AllowSSLRequestsOnly"
    effect = "Deny"
    principals {
      type = "*"
      identifiers = [ "*" ]
    }
    actions = [ "s3:*" ]
    resources = [
      aws_s3_bucket.bucket2.arn,
      "${aws_s3_bucket.bucket2.arn}/*"
    ]
    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = [ "false" ]
    }
  }

  statement {
    sid = "AllowVPCAccess"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.bucket2.arn,
      "${aws_s3_bucket.bucket2.arn}/*"
    ]
    condition {
      test = "StringEquals"
      variable = "aws:SourceVpc"
      values = [ aws_vpc.troubleshooting.id ]
    }
  }
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "${var.s3_bucket_prefix}-proving-ground-troubleshooting-bucket2"
  acl = "private"
  force_destroy = true

  tags = {
    Environment = "proving_ground"
    Purpose = "troubleshooting"
    Scope = "bucket2"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket2" {
  bucket = aws_s3_bucket.bucket2.id

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "bucket2_policy" {
  bucket = aws_s3_bucket.bucket2.id
  policy = data.aws_iam_policy_document.bucket2_policy.json
}
