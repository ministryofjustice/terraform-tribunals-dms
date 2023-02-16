#! /bin/bash

source ./connect-to-aws.sh

#retrieve existing security groups 
aws ec2 describe-instances --instance-ids ${EC2_INSTANCE_ID} --profile dts-legacy-apps-user --query "Reservations[].Instances[].SecurityGroups[].GroupId" > security_groups

existing_group_ids="$(sed 's/[^a-zA-Z0-9-]//g' security_groups)"
echo existing group ids : $existing_group_ids
echo DMS security group id : ${DMS_SECURITY_GROUP}
aws ec2 modify-instance-attribute --instance-id ${EC2_INSTANCE_ID} --groups $existing_group_ids ${DMS_SECURITY_GROUP}

aws ec2 describe-instances --instance-ids ${EC2_INSTANCE_ID} --profile dts-legacy-apps-user --query "Reservations[].Instances[].SecurityGroups[].GroupId" > security_groups
cat security_groups