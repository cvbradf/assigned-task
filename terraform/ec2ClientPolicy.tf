# Trust policy for EC2 service
data "aws_iam_policy_document" "ec2_assume_role" {
 statement {
   actions = ["sts:AssumeRole"]

   principals {
     type        = "Service"
     identifiers = ["ec2.amazonaws.com"]
   }
 }
}

# Client Role and Policies
resource "aws_iam_role" "client_role" {
 name               = "Client-S3-Read-Role"
 assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

 tags = {
   Name        = "Client S3 Read Role"
   Environment = "production"
 }
}

# Client S3 Read Policy
resource "aws_iam_policy" "client_s3_read_policy" {
 name        = "Client-S3-Read-Policy"
 description = "Allows client to read from S3 bucket"

 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Sid    = "S3ReadAccess"
       Effect = "Allow"
       Action = [
         "s3:GetObject",
         "s3:GetObjectVersion",
         "s3:GetObjectAcl",
         "s3:ListBucket",
         "s3:GetBucketLocation",
         "s3:ListBucketVersions"
       ]
       Resource = [
         "arn:aws:s3:::${var.s3_bucket_name}",
         "arn:aws:s3:::${var.s3_bucket_name}/*"
       ]
     }
   ]
 })
}

# Attach S3 read policy to client role
resource "aws_iam_role_policy_attachment" "attach_client_policy" {
 role       = aws_iam_role.ec2_client_role.name
 policy_arn = aws_iam_policy.client_s3_read_policy.arn
}

