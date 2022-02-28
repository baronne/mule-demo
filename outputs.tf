# output "control_host_instance_id" {
#   value = module.control_host.id
# }

output "apihost_instance_id" {
  value = module.api_host[*].id
}

output "apihost_public_ip" {
  value = module.api_host[*].public_ip
}

# output "db-password" {
#   value = module.db.db_instance_password
#   sensitive = true
# }

output "rds_endpoint" {
  value = module.rds_mysql[*].db_instance_address
}

output "api_console_url" {
  value = "http://${module.api_host[0].public_ip}:8081/console"
}