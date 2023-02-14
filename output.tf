output "dms_replication_instance" {
  value = join("", [aws_dms_replication_instance.replication-instance.replication_instance_public_ips[0], "/32"])
}