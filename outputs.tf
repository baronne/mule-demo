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