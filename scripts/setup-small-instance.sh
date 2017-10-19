#!/bin/bash

# Set up a small & cheap instance for developing scripts, munging data.

set -e
set -x

export vpcId=vpc-0c0f686b
export internetGatewayId=igw-7d9caf19
export subnetId=subnet-c434a8a3
export securityGroupId=sg-6459751c

# Note using AMI ami-b43d1ec7 instead of ami-bc508adc here, for eu-west-1
export instanceId=`aws ec2 run-instances --image-id ami-b43d1ec7 --count 1 --instance-type t2.micro --key-name devops-310817 --security-group-ids $securityGroupId --subnet-id $subnetId --associate-public-ip-address --block-device-mapping "[ { \"DeviceName\": \"/dev/sda1\", \"Ebs\": { \"VolumeSize\": 128, \"VolumeType\": \"gp2\" } } ]" --query 'Instances[0].InstanceId' --output text`
export allocAddr=eipalloc-ce7d7af4

echo Waiting for instance start...
aws ec2 wait instance-running --instance-ids $instanceId
sleep 10 # wait for ssh service to start running too
export assocId=`aws ec2 associate-address --instance-id $instanceId --allocation-id $allocAddr --query 'AssociationId' --output text`
export instanceUrl=`aws ec2 describe-instances --instance-ids $instanceId --query 'Reservations[0].Instances[0].PublicDnsName' --output text`
echo securityGroupId=$securityGroupId
echo subnetId=$subnetId
echo instanceId=$instanceId
echo instanceUrl=$instanceUrl
