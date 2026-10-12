data "aws_ami" "amazon_linux_2" {
  most_recent = true

  owners = [ "amazon" ]

  filter {
    name = "name"
    values = [ "amzn2-ami-hvm*" ]
  }
}

resource "aws_launch_configuration" "alpha_lc" {
  name_prefix = "alpha_lc"
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.alpha_instance.arn
  key_name = var.key_pair_name

  security_groups = [
    aws_security_group.internet_access.id,
    aws_security_group.ssh_access.id,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "alpha_asg" {
  name = "alpha_asg"
  launch_configuration = aws_launch_configuration.alpha_lc.name
  health_check_type = "EC2"
  min_size = 1
  max_size = 1

  vpc_zone_identifier = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id,
  ]

  tag {
    key = "Name"
    value = "alpha"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "proving_ground"
    propagate_at_launch = true
  }
  tag {
    key = "Purpose"
    value = "troubleshooting"
    propagate_at_launch = true
  }
  tag {
    key = "Scope"
    value = "public"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "beta_lc" {
  name_prefix = "beta_lc"
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.beta_instance.arn
  key_name = var.key_pair_name

  security_groups = [
    aws_security_group.internet_access.id,
    aws_security_group.ssh_access.id,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "beta_asg" {
  name = "beta_asg"
  launch_configuration = aws_launch_configuration.beta_lc.name
  health_check_type = "EC2"
  min_size = 1
  max_size = 1

  vpc_zone_identifier = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1b.id,
  ]

  tag {
    key = "Name"
    value = "beta"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "proving_ground"
    propagate_at_launch = true
  }
  tag {
    key = "Purpose"
    value = "troubleshooting"
    propagate_at_launch = true
  }
  tag {
    key = "Scope"
    value = "public"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "omega_lc" {
  name_prefix = "omega_lc"
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.omega_instance.arn
  key_name = var.key_pair_name

  security_groups = [
    aws_security_group.private_ssh_access.id,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "omega_asg" {
  name = "omega_asg"
  launch_configuration = aws_launch_configuration.omega_lc.name
  health_check_type = "EC2"
  min_size = 1
  max_size = 1

  vpc_zone_identifier = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1b.id,
  ]

  tag {
    key = "Name"
    value = "omega"
    propagate_at_launch = true
  }
  tag {
    key = "Environment"
    value = "proving_ground"
    propagate_at_launch = true
  }
  tag {
    key = "Purpose"
    value = "troubleshooting"
    propagate_at_launch = true
  }
  tag {
    key = "Scope"
    value = "private"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
