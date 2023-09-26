resource "helm_release" "prometheus" {
  chart            = var.prometheus_chart
  name             = var.prometheus_name
  create_namespace = var.prometheus_namespace_creation
  namespace        = var.prometheus_namespace
  repository       = var.prometheus_repository

  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }
}

resource "random_password" "grafana" {
  length           = 24
  override_special = "@#"
}

resource "helm_release" "grafana" {
  depends_on = [helm_release.prometheus]
  name       = var.grafana_name
  chart      = var.grafana_chart
  namespace  = var.grafana_namespace
  repository = var.grafana_repository

  set {
    name  = "adminUser"
    value = "admin"
  }

  set {
    name  = "adminPassword"
    value = random_password.grafana.result
  }
}