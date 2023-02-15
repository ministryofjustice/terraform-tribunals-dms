variable "db_hostname"{
  description = "database hostname credentials"
}

variable "db_username"{
  description = "database username credentials"
}

variable "db_password"{
  description = "database password credentials"
}

variable "dms_source_db_password" {
    description = "dms source database password"
}

variable "dms_source_db_hostname" {
    description = "dms source database hostname"
}

variable "dms_source_db_username" {
    description = "dms source database username"
}

variable "dms_replication_instance" {
    description = "returns dms replication instance public ip"
}

variable "region" {
    description = "AWS Region"
}

variable "dms_target_account_access_key" {
    description = "dms target database access key"
}

variable "dms_target_account_secret_key" {
    description = "dms target database secret key"
}

variable "db_instance"{
  description = "rds database instance"
}

variable "application_name"{ 
}

variable "source_db_name"{ 
}

variable "target_db_name"{ 
}

variable "environment" {
  type = string 
}