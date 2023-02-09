#! /bin/bash

source ./connect-to-aws.sh

aws rds modify-db-instance --db-instance-identifier postgresql-staging --vpc-security-group-ids sg-08244ba362f922899 sg-0e0f5cf0883f81945 sg-04e9fe073afcc6b65 ${DMS_SECURITY_GROUP}