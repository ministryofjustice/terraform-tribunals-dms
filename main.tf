provider "aws" {
  region     = var.region
  access_key = var.dms_source_account_access_key
  secret_key = var.dms_source_account_secret_key
  alias   = "mojdsd"
}

resource "aws_dms_endpoint" "source" {
  database_name               = var.source_db_name
  endpoint_id                 = "tf-tribunals-${var.application_name}-source-${var.environment}"
  endpoint_type               = "source"
  engine_name                 = "sqlserver"
  password                    = var.dms_source_db_password
  port                        = 1433
  server_name                 = var.dms_source_db_hostname
  ssl_mode                    = "none"

  username = var.dms_source_db_username
}

resource "aws_dms_endpoint" "target" {
  depends_on = [var.db_instance]

  database_name               = var.target_db_name
  endpoint_id                 = "tf-tribunals-${var.application_name}-target-${var.environment}"
  endpoint_type               = "target"
  engine_name                 = "sqlserver"
  password                    = var.db_password
  port                        = 1433
  server_name                 = var.db_hostname
  ssl_mode                    = "none"

  username = var.db_username
}

resource "aws_dms_replication_instance" "replication-instance" {
  allocated_storage            = 100
  apply_immediately            = true
  availability_zone            = "eu-west-2a"
  engine_version               = "3.4.7"
  multi_az                     = false
  publicly_accessible          = true
  auto_minor_version_upgrade   = true
  replication_instance_class   = "dms.t3.large"
  replication_instance_id      = "tf-${var.application_name}-${var.environment}"
}

resource "aws_dms_replication_task" "migration-task" {
  depends_on = [null_resource.setup_target_rds_security_group, var.db_instance, aws_dms_endpoint.target, aws_dms_endpoint.source, aws_dms_replication_instance.replication-instance]
  #depends_on = [var.db_instance, aws_dms_endpoint.target, aws_dms_endpoint.source, aws_dms_replication_instance.replication-instance]

  migration_type            = "full-load-and-cdc"
  replication_instance_arn  = aws_dms_replication_instance.replication-instance.replication_instance_arn
  replication_task_id       = "tf-tribunals-${var.application_name}-migration-task-${var.environment}"
  replication_task_settings = "{\"FullLoadSettings\": {\"TargetTablePrepMode\": \"TRUNCATE_BEFORE_LOAD\"}}"
  source_endpoint_arn       = aws_dms_endpoint.source.endpoint_arn
  table_mappings            = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"dbo\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
  target_endpoint_arn = aws_dms_endpoint.target.endpoint_arn
  start_replication_task = true
}

resource "aws_security_group" "dms_access_rule" {
  name = "dms_access_rule"
  description = "allow dms access to the database"

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    description = "Allow DMS to connect to source database"
    cidr_blocks = [var.dms_replication_instance]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  provider = aws.mojdsd

 }

 resource "null_resource" "setup_target_rds_security_group" {
  depends_on = [aws_dms_replication_instance.replication-instance]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command =  "chmod +x ./setup-security-group.sh; ./setup-security-group.sh"

    environment = {
      DMS_SECURITY_GROUP  = aws_security_group.dms_access_rule.id
      EC2_INSTANCE_ID     = var.ec2_instance_id
    }
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}