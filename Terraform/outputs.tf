output "pass" {
  value     = random_password.grafana.result
  sensitive = true
}

output "ssh_redis" {
  value = "ssh -i ${local_file.admin_rsa_file.filename} ${local.admin_username}@${module.vm.vm_fqdn}"
}