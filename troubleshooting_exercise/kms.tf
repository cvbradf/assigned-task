data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }
    actions = [ "kms:*" ]
    resources = [ "*" ]
  }

  statement {
    sid = "Allow use of the key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.beta_instance.arn,
        aws_iam_role.omega_instance.arn,
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
    resources = [ "*" ]
  }

  statement {
    sid = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.beta_instance.arn,
        aws_iam_role.omega_instance.arn,
      ]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = [ "*" ]
    condition {
      test = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values = [ "true" ]
    }
  }
}

resource "aws_kms_key" "kms_key" {
  description = "KMS key for troubleshooting exercise"
  policy = data.aws_iam_policy_document.kms_policy.json
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "kms_key" {
  name = "alias/proving-ground/troubleshooting"
  target_key_id = aws_kms_key.kms_key.id
}
