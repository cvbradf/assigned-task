# Web Server Role and Policies
resource "aws_iam_role" "web_server_role" {
 name               = "WebServer-EC2-Role"
 assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

 tags = {
   Name        = "Web Server EC2 Role"
   Environment = "production"
 }
}

# Web Server S3 Write Policy
resource "aws_iam_policy" "web_server_s3_write_policy" {
 name        = "WebServer-S3-Write-Policy"
 description = "Allows web server to write to S3 bucket and describe EC2 instances"

 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Sid    = "S3WriteAccess"
       Effect = "Allow"
       Action = [
         "s3:PutObject",
         "s3:PutObjectAcl",
         "s3:DeleteObject",
         "s3:ListBucket",
         "s3:GetObject",
         "s3:GetBucketLocation"
       ]
       Resource = [
         "arn:aws:s3:::${var.s3_bucket_name}",
         "arn:aws:s3:::${var.s3_bucket_name}/*"
       ]
     },
     {
       Sid    = "EC2DescribeAccess"
       Effect = "Allow"
       Action = [
         "ec2:DescribeInstances",
         "ec2:DescribeInstanceStatus",
         "ec2:DescribeInstanceAttribute",
         "ec2:DescribeImages",
         "ec2:DescribeSnapshots",
         "ec2:DescribeVolumes",
         "ec2:DescribeSecurityGroups",
         "ec2:DescribeKeyPairs",
         "ec2:DescribeNetworkInterfaces",
         "ec2:DescribeSubnets",
         "ec2:DescribeVpcs",
         "ec2:DescribeAvailabilityZones",
         "ec2:DescribeRegions"
       ]
       Resource = "*"
     }
   ]
 })
}



