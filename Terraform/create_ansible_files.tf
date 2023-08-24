# Create appli/commun variables file for ansible
resource "local_file" "appli_commun_main_yml" {
  filename        = "${path.module}/../Ansible/roles/redis/commun/defaults/main.yml"
  file_permission = "0644"
  content = templatefile("${path.module}/templates/users.tftpl",
    {
      tpl_users           = local.users
      tpl_random_password = random_password.users_vm.result
  })
}