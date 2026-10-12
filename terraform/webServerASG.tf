# Web Server EC2 Instance
resource "aws_launch_template" "web-server" {
  
  name_prefix = "web_server-"
  image_id    = data.aws_ami.apache-ebs-puppet.image_id

  instance_type = var.instance_type
  key_name      = var.key_pair_name != "" ? var.key_pair_name : null

  vpc_security_group_ids = [aws_security_group.server-sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      {
        "LaunchedBy" = "AutoScaling"
      }
    )
  }
}

# Auto Scaling Group referencing both instances through launch template
resource "aws_autoscaling_group" "web-server" {
  name                      = "web_server"
  vpc_zone_identifier       = data.aws_subnets.default.ids
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300
  default_cooldown          = 300

  # Inline user data - automatically base64 encoded


  launch_template {
    id      = aws_launch_template.web-server.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "web-server"
    propagate_at_launch = true
  }
}

data "aws_instances" "web_server_instances" {
  depends_on = [aws_autoscaling_group.web-server]

  filter {
    name   = "tag:Name"
    values = ["web-server"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

