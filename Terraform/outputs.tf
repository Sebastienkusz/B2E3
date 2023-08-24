output "pass" {
  value     = random_password.grafana.result
  sensitive = true
}

output "admin_ssh_redis" {
  value = "ssh -i ${local_file.admin_rsa_file.filename} ${local.admin_username}@${module.vm.vm_fqdn}"
}

output "users_ssh_redis" {
  value = [for user_name, user_value in local.users : "${user_name} : ssh -i ~/.ssh/${user_value.private_key} ${user_name}@${module.vm.vm_fqdn} "]
}