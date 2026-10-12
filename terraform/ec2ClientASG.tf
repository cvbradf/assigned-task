# Client EC2 Instance
resource "aws_launch_template" "ec2-client" {
  
  name_prefix            = "ec2_client-"
  image_id               = data.aws_ami.ec2-client.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name != "" ? var.key_pair_name : null
  
  vpc_security_group_ids = [aws_security_group.client-sg.id]
  # Inline user data - automatically base64 encoded
  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo dnf update -y
    sudo dnf install -y httpd
    sudo systemctl enable httpd
    sudo systemctl start httpd
    
    curl -o /tmp/index.html http://${data.aws_instances.web_server_instances.public_ips[0]}/index.html 
    EOF
  )
  
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_client_profile.name
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
resource "aws_autoscaling_group" "ec2-client" {
  name                      = "ec2_client"
  vpc_zone_identifier       = data.aws_subnets.default.ids
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300
  default_cooldown          = 300

  launch_template {
    id  = aws_launch_template.ec2-client.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ec2-client"
    propagate_at_launch = true
  }  
}