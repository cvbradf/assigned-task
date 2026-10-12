import boto3
import json
import logging
from datetime import datetime, timezone
from botocore.exceptions import ClientError

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def get_webserver_ips(region='us-east-1'):
   """
   Get IP addresses of web server instances

   Returns:
       List of dictionaries with instance information
   """
   ec2 = boto3.client('ec2', region_name=region)

   try:
       # Query for running instances with 'web' in name or tags
       response = ec2.describe_instances(
           Filters=[
               {'Name': 'instance-state-name', 'Values': ['running']},
               {'Name': 'tag:Name', 'Values': ['*web*', '*Web*', '*WEB*']},
           ]
       )

       webservers = []

       for reservation in response['Reservations']:
           for instance in reservation['Instances']:
               # Get instance name from tags
               name = 'Unknown'
               for tag in instance.get('Tags', []):
                   if tag['Key'] == 'Name':
                       name = tag['Value']
                       break

               # Extract IP information
               webserver_info = {
                   'instance_id': instance['InstanceId'],
                   'name': name,
                   'private_ip': instance.get('PrivateIpAddress'),
                   'public_ip': instance.get('PublicIpAddress'),
                   'instance_type': instance['InstanceType'],
                   'availability_zone': instance['Placement']['AvailabilityZone'],
                   'launch_time': instance['LaunchTime'].isoformat(),
                   'collected_at': datetime.now(timezone.utc).isoformat()
               }

               webservers.append(webserver_info)

       logger.info(f"Found {len(webservers)} web server instances")
       return webservers

   except ClientError as e:
       logger.error(f"Error querying EC2: {e}")
       return []

def upload_to_s3(data, bucket_name, file_key):
   """
   Upload data to S3 bucket

   Args:
       data: Data to upload (will be converted to JSON)
       bucket_name: S3 bucket name
       file_key: S3 object key (file path)

   Returns:
       True if successful, False otherwise
   """
   s3 = boto3.client('s3')

   try:
       # Convert data to JSON
       json_data = json.dumps(data, indent=2, default=str)

       # Upload to S3
       s3.put_object(
           Bucket=bucket_name,
           Key=file_key,
           Body=json_data.encode('utf-8'),
           ContentType='application/json',
           ServerSideEncryption='AES256'
       )

       logger.info(f"Successfully uploaded to s3://{bucket_name}/{file_key}")
       return True

   except ClientError as e:
       logger.error(f"Error uploading to S3: {e}")
       return False

def main():
   """Main function"""
   # Configuration
   S3_BUCKET = 'my-webserver-ips-bucket'  # Change this to your bucket name
   AWS_REGION = 'us-east-1'               # Change this to your region

   # Get web server IPs
   logger.info("Collecting web server IP addresses...")
   webservers = get_webserver_ips(region=AWS_REGION)

   if not webservers:
       logger.warning("No web servers found")
       return

   # Create report
   report = {
       'metadata': {
           'collection_time': datetime.now(timezone.utc).isoformat(),
           'region': AWS_REGION,
           'total_servers': len(webservers)
       },
       'webservers': webservers
   }

   # Generate file key with timestamp
   timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
   file_key = f"webserver-ips/webserver_ips_{timestamp}.json"

   # Upload to S3
   logger.info("Uploading to S3...")
   if upload_to_s3(report, S3_BUCKET, file_key):
       logger.info("Process completed successfully")

       # Print summary
       print("\n" + "="*50)
       print("WEB SERVER IP COLLECTION COMPLETED")
       print("="*50)
       print(f"Total servers found: {len(webservers)}")
       print(f"Uploaded to: s3://{S3_BUCKET}/{file_key}")
       print("\nServer details:")
       for server in webservers:
           print(f"  {server['name']} ({server['instance_id']})")
           print(f"    Private IP: {server['private_ip'] or 'N/A'}")
           print(f"    Public IP: {server['public_ip'] or 'N/A'}")
       print("="*50)
   else:
       logger.error("Failed to upload to S3")

if __name__ == '__main__':
   main()