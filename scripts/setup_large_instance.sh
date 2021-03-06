#!/bin/bash
#
# This script is derived from the 'setup_p2.sh' script in the fast.ai course repository.
# I didn't really want to create new VPCs, security groups, and keys etc. for my p2 box so I've hacked this
# to suit my purposes.
# Note that this uses a different AMI image from the original, as that one wasn't available in eu-west-1(!).

set -e
set -x

# Use 'Default' VPC instead.
#export vpcId=`aws ec2 create-vpc --cidr-block 10.0.0.0/28 --query 'Vpc.VpcId' --output text`
export vpcId=vpc-0c0f686b

# This VPC already has DNS support
#aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-support "{\"Value\":true}"
#aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-hostnames "{\"Value\":true}"

# It has an IG as well
#export internetGatewayId=`aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text`
#aws ec2 attach-internet-gateway --internet-gateway-id $internetGatewayId --vpc-id $vpcId
export internetGatewayId=igw-7d9caf19

# And a subnet
export subnetId=subnet-c434a8a3
#export subnetId=`aws ec2 create-subnet --vpc-id $vpcId --cidr-block 10.0.0.0/28 --query 'Subnet.SubnetId' --output text`

#export routeTableId=`aws ec2 create-route-table --vpc-id $vpcId --query 'RouteTable.RouteTableId' --output text`
#aws ec2 associate-route-table --route-table-id $routeTableId --subnet-id $subnetId
#aws ec2 create-route --route-table-id $routeTableId --destination-cidr-block 0.0.0.0/0 --gateway-id $internetGatewayId

# I have a perfectly valid security group as well, thanks
export securityGroupId=sg-6459751c
# export securityGroupId=`aws ec2 create-security-group --group-name my-security-group --description "Generated by setup_vpn.sh" --vpc-id $vpcId --query 'GroupId' --output text`
# aws ec2 authorize-security-group-ingress --group-id ${securityGroupId} --protocol tcp --port 22 --cidr 0.0.0.0/0
# aws ec2 authorize-security-group-ingress --group-id ${securityGroupId} --protocol tcp --port 8888-8898 --cidr 0.0.0.0/0

# It is already configured with a key pair too
#aws ec2 create-key-pair --key-name aws-key --query 'KeyMaterial' --output text > ~/.ssh/aws-key.pem
#chmod 400 ~/.ssh/aws-key.pem

# OK, so actually create the instance
# Note using AMI ami-b43d1ec7 instead of ami-bc508adc here, for eu-west-1
export instanceId=`aws ec2 run-instances --image-id ami-b43d1ec7 --count 1 --instance-type p2.xlarge --key-name devops-310817 --security-group-ids $securityGroupId --subnet-id $subnetId --associate-public-ip-address --block-device-mapping "[ { \"DeviceName\": \"/dev/sda1\", \"Ebs\": { \"VolumeSize\": 128, \"VolumeType\": \"gp2\" } } ]" --query 'Instances[0].InstanceId' --output text`
export allocAddr=eipalloc-b4ad998e

echo Waiting for instance start...
aws ec2 wait instance-running --instance-ids $instanceId
sleep 10 # wait for ssh service to start running too
export assocId=`aws ec2 associate-address --instance-id $instanceId --allocation-id $allocAddr --query 'AssociationId' --output text`
export instanceUrl=`aws ec2 describe-instances --instance-ids $instanceId --query 'Reservations[0].Instances[0].PublicDnsName' --output text`
echo securityGroupId=$securityGroupId
echo subnetId=$subnetId
echo instanceId=$instanceId
echo instanceUrl=$instanceUrl
