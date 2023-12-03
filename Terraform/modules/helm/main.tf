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

  # Admin login
  set {
    name  = "adminUser"
    value = var.grafana_admin
  }

  set {
    name  = "adminPassword"
    value = random_password.grafana.result
  }

  # Ingress
  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "azure/application-gateway"
  }

  set {
    name  = "ingress.path"
    value = "/grafana"
  }

  set {
    name  = "ingress.pathType"
    value = "Prefix"
  }

  set {
    name  = "ingress.hosts"
    value = var.server_domain
  }

  # Ingress cert manager
  set {
    name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-issuer"
  }

  set {
    name  = "ingress.annotations.cert-manager\\.io/acme-challenge-type"
    value = "http01"
  }

  set {
    name  = "ingress.tls[0].hosts"
    value = var.server_domain
  }

  set {
    name  = "ingress.tls[0].secretName"
    value = "letsencrypt"
  }

  # Ingress for Grafana path
  set {
    name  = "grafana\\.ini.server.domain"
    value = var.server_domain
  }

  set {
    name  = "grafana\\.ini.server.root_url"
    value = "%(protocol)s://%(domain)s/grafana"
  }

  set {
    name  = "grafana\\.ini.server.serve_from_sub_path"
    value = true
  }

  # Datasource Grafana
  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "Prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].url"
    value = "http://prometheus-server.${var.grafana_namespace}.svc.cluster.local"
  }

  # Dashboard Grafana
  values = [
    <<EOF
dashboardProviders:
  dashboardproviders.yaml:
    apiVersion: 1
    providers:
    - name: 'default'
      orgId: 1
      folder: ''
      type: file
      disableDeletion: false
      editable: true
      options:
        path: /var/lib/grafana/dashboards/default

dashboards:
  default:
    kubernetes:
      json: |
        ${indent(8, file("${path.root}/dashboards/Node_Exporter.json"))}
    azure:
      gntId: 14986
      version: 1
EOF
  ]

}

# Install nginx ingress controller form helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
resource "helm_release" "ingress-azure" {
  repository       = var.ingress_repository
  chart            = var.ingress_chart
  name             = var.ingress_name
  namespace        = var.ingress_namespace
  atomic           = true
  cleanup_on_fail  = true
  reuse_values     = true
  skip_crds        = true
  create_namespace = var.ingress_namespace_creation
  version          = "1.7.2"

  set {
    name  = "appgw.subscriptionId"
    value = var.subscription_id
  }
  set {
    name  = "appgw.resourceGroup"
    value = var.resource_group_name
  }
  set {
    name  = "appgw.name"
    value = var.gateway_name
  }
  set {
    name  = "appgw.usePrivateIP"
    value = "false"
  }
  set {
    name  = "armAuth.type"
    value = "servicePrincipal"
  }
  set {
    name  = "armAuth.secretJSON"
    value = "ewogICJjbGllbnRJZCI6ICJlNTM1ODU1OS0wYmI5LTRmMDAtODY3Ny1jNjM2ODVkY2Y5ZDAiLAogICJjbGllbnRTZWNyZXQiOiAiWG9yOFF+d2tWbTBrZmh4ZmZaVzQ1SHF6TlRSR0FIUE5MOF9EYWFvcyIsCiAgInN1YnNjcmlwdGlvbklkIjogImM1NmFlYTJjLTUwZGUtNGFkYy05NjczLTZhODAwODg5MmMyMSIsCiAgInRlbmFudElkIjogIjE2NzYzMjY1LTE5OTgtNGM5Ni04MjZlLWMwNDE2MmIxZTA0MSIsCiAgImFjdGl2ZURpcmVjdG9yeUVuZHBvaW50VXJsIjogImh0dHBzOi8vbG9naW4ubWljcm9zb2Z0b25saW5lLmNvbSIsCiAgInJlc291cmNlTWFuYWdlckVuZHBvaW50VXJsIjogImh0dHBzOi8vbWFuYWdlbWVudC5henVyZS5jb20vIiwKICAiYWN0aXZlRGlyZWN0b3J5R3JhcGhSZXNvdXJjZUlkIjogImh0dHBzOi8vZ3JhcGgud2luZG93cy5uZXQvIiwKICAic3FsTWFuYWdlbWVudEVuZHBvaW50VXJsIjogImh0dHBzOi8vbWFuYWdlbWVudC5jb3JlLndpbmRvd3MubmV0Ojg0NDMvIiwKICAiZ2FsbGVyeUVuZHBvaW50VXJsIjogImh0dHBzOi8vZ2FsbGVyeS5henVyZS5jb20vIiwKICAibWFuYWdlbWVudEVuZHBvaW50VXJsIjogImh0dHBzOi8vbWFuYWdlbWVudC5jb3JlLndpbmRvd3MubmV0LyIKfQo=" #"$(az ad sp create-for-rbac --role Contributor --scope /subscriptions/${var.subscription_id} --sdk-auth | base64)"
  }
  set {
    name  = "rbac.enabled"
    value = "true"
  }
}

resource "helm_release" "cert_manager" {
  name             = var.cert_manager_name
  namespace        = var.cert_manager_namespace
  create_namespace = var.cert_manager_namespace_creation
  chart            = var.cert_manager_chart
  repository       = var.cert_manager_repository
  version          = "v1.13.1"
  set {
    name  = "installCRDs"
    value = "true"
  }  
}

# resource "kubectl_manifest" "clusterissuer_letsencrypt_prod" {
#   depends_on = [helm_release.cert_manager]
#   yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: ClusterIssuer
# metadata:
#   name: letsencrypt-issuer
#   namespace: cert-manager
# spec:
#   acme:
#     email: aazzce@aazzee.com
#     server: https://acme-v02.api.letsencrypt.org/directory # Used for prod environnement
#     privateKeySecretRef:
#       name: letsencrypt
#     solvers:
#       - http01:
#           ingress:
#             class: azure/application-gateway
# YAML
# }

# resource "helm_release" "rancher" {
#   name             = var.rancher_name
#   namespace        = var.rancher_namespace
#   create_namespace = var.rancher_namespace_creation
#   chart            = var.rancher_chart
#   repository       = var.rancher_repository
#   version          = "v1.13.1"
#   set {
#     name  = "installCRDs"
#     value = "true"
#   }
# }