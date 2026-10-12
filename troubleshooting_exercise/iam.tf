data "aws_iam_policy_document" "instance_role_policy" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "alpha_instance" {
  name = "alpha_instance"
  assume_role_policy = data.aws_iam_policy_document.instance_role_policy.json

  tags = {
    Name = "alpha_instance"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

resource "aws_iam_instance_profile" "alpha_instance" {
  name = aws_iam_role.alpha_instance.name
  role = aws_iam_role.alpha_instance.name
}

resource "aws_iam_role" "beta_instance" {
  name = "beta_instance"
  assume_role_policy = data.aws_iam_policy_document.instance_role_policy.json

  tags = {
    Name = "beta_instance"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

resource "aws_iam_instance_profile" "beta_instance" {
  name = aws_iam_role.beta_instance.name
  role = aws_iam_role.beta_instance.name
}

resource "aws_iam_role" "omega_instance" {
  name = "omega_instance"
  assume_role_policy = data.aws_iam_policy_document.instance_role_policy.json

  tags = {
    Name = "omega_instance"
    Environment = "proving_ground"
    Purpose = "troubleshooting"
  }
}

resource "aws_iam_instance_profile" "omega_instance" {
  name = aws_iam_role.omega_instance.name
  role = aws_iam_role.omega_instance.name
}
