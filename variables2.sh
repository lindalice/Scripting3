#!/bin/bash

#Make an IMDSv2 request
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

#Define and retrieve the instance information
region=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
az_code=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
privateip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
publicip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
instance_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" "Name=key,Values=Name" --region $region --query 'Tags[0].Value' --output text)
instance_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
account_number=$(aws sts get-caller-identity --query 'Account' --output text)

# Write the variables information to the output file
cat << EOF >> /opt/shell_output.txt
region-name: $region
az-code: $az_code
private-ip: $privateip
public-ip: $publicip
instance-name: $instance_name
instance-id: $instance_id
account-number: $account_number
EOF
