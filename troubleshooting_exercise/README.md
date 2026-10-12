# Troubleshooting Exercise

## Purpose
We have provided an exercise to test basic AWS troubleshooting skills. The exercise consists of three instances and two buckets. The instances are unable to send or receive files to/from the buckets. You must update the code to enable the instances to send and receive files to/from the buckets. This should be done in a secure manner (do not open unnecessary access).

## Prerequisites
1.  Proving ground assumes basic proficiency in AWS which includes an understanding of and how to create, modify and delete the following through the AWS console: IAM roles, VPCs, Subnets, Routing Tables, Security Groups, NACLs, EC2s, EBS volumes, S3 buckets, Launch Configurations and Auto Scaling Groups.

2.  You will need a workstation with Terraform installed on it. The code was tested on Terraform verson 1.0.8.

3.  You will need an existing AWS key pair.

## Hints
1.  We have provided you with the ip-ranges.json file, downloaded from AWS. This provides CIDR blocks for AWS service APIs for each region.

## Setup
The Terraform code sets up a fully functioning environment. The environment consists of a VPC with public and private subnets. Two instances, alpha and beta, are deployed in the public subnets and one instance, omega, is deployed in the private subnets. Route tables, network ACLs, and security groups are also created for the VPC. Two S3 buckets (referred to as bucket1 and bucket2) are created with bucket policies. One KMS key is also created with its own policy.

The Terraform code requires three variables to be set:
  - **s3_bucket_prefix**: This prefix is prepended to the bucket names to ensure global name uniqueness.
  - **my_ip_addr**: The IP address of the machine you will be connecting to the EC2 instances from. If you are behind a NAT, you can Google "what is my ip" to determine the correct IP address.
  - **key_pair_name**: The name of the existing AWS key pair. This key pair will be used to authenticate with the EC2 instances.

To create the environment, run the following Terraform commands (example values are used):
```
terraform init
terraform apply -var "s3_bucket_prefix=myprefix" -var "my_ip_addr=1.1.1.1" -var "key_pair_name=MyKeyPair"
```

You can SSH into the alpha and beta instance using their public IP addresses:
```
ssh -i <path to SSH private key> ec2-user@<public IP address>
```

To SSH into the omega instance, you need to connect through one of the public EC2 instances (alpha or beta):
```
ssh -i <path to SSH private key> ec2-user@<omega IP address> -o "proxycommand ssh -W %h:%p -i <path to SSH private key> ec2-user@<alpha public IP address>"
```

Once you have SSH'ed into the EC2 instances, create a file and attempt to write it to the S3 buckets.
```
aws s3 cp <file path> s3://<s3_bucket_prefix>-proving-ground-troubleshooting-bucket1/
aws s3 cp <file path> s3://<s3_bucket_prefix>-proving-ground-troubleshooting-bucket2/
```

## Tasks
The task has been set. The task is plain and clear.

Update the Terraform code so that all three EC2 instances can send and receive files to/from both S3 buckets.

## Cleanup
To cleanup the troubleshooting environment, run the **terraform destroy** command:
```
terraform destroy -var "s3_bucket_prefix=myprefix" -var "my_ip_addr=1.1.1.1" -var "key_pair_name=MyKeyPair"
```

## Next Steps
Upon successful completion of the final task, please perform the following steps in order:
1.  Commit your code to a private GitHub (https://github.com); there is no charge to create an account and repository.  The code committed should enable a collaborator to clone the project and deploy the solution to an AWS environment.
2.  Add the following GitHub users as Collaborators:
    - mfmjos (David C.)
3.  Send an e-mail to the following to let them know you're ready for a code review:
    - dacompton@gmail.com

Upon successful verification of the code you will be granted access to the infrastructure on the customer network.
