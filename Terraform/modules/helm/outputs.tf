output "random_password" {
  value       = random_password.grafana.result
  description = "Network name"
  sensitive   = true
}