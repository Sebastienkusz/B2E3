plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_module_version" {
  enabled = true
  exact = true
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}