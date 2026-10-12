# Output the Web Server Public Ip Address
output "asg_instance_public_ips" {
  description = "The public IP addresses of the EC2 instances in the Auto Scaling Group."
  value       = data.aws_instances.web_server_instances.public_ips[0]
}
