#! /bin/bash

export AWS_ACCESS_KEY_ID=$DMS_TARGET_ACCOUNT_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=$DMS_TARGET_ACCOUNT_SECRET_KEY
export AWS_REGION="eu-west-2"

aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile dts-legacy-apps-user &&
aws configure set aws_secret_access_key "$AWS_ACCESS_KEY_SECRET" --profile dts-legacy-apps-user &&
aws configure set region "$AWS_REGION" --profile dts-legacy-apps-user &&
aws configure set output "json" --profile dts-legacy-apps-user