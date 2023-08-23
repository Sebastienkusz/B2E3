output "pass" {
  value     = random_password.grafana.result
  sensitive = true
}

output "admin_ssh_redis" {
  value = "ssh -i ${local_file.admin_rsa_file.filename} ${local.admin_username}@${module.vm.vm_fqdn}"
}

output "list_users_ssh_redis" {
  value = [ for user_name, user_value in local.users :user_name ]
}

output "users_ssh_redis" {
  value = "ssh username@${module.vm.vm_fqdn}"
}