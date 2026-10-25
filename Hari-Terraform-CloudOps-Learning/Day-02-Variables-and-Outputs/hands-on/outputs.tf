output "project_details" {
  description = "CloudOps configuration details"

  value = {
    project_name      = var.project_name
    environment       = var.environment
    instance_count    = var.instance_count
    enable_monitoring = var.enable_monitoring
  }
}
output "availability_zones" {
  value = var.availability_zones
}

output "server_tags" {
  value = var.common_tags
}

output "server_configuration" {
  value = var.server_config
}

