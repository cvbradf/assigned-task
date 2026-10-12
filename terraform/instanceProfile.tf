# IAM Web Server Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "rocky-linux-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# IAM Client Instance Profile
resource "aws_iam_instance_profile" "ec2_client_profile" {
  name = "ec2-client-profile"
  role = aws_iam_role.ec2_client_role.name
}