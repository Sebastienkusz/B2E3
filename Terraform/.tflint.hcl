plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

rule "terraform_module_version" {
  enabled = true
  exact = true
}

rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = false
  style = "flexible"
  default_branches = ["main"]
}