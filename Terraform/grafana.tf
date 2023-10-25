# resource "null_resource" "get_credentials" {
#   depends_on = [module.aks]
#   provisioner "local-exec" {
#     working_dir = "${path.root}"
#     interpreter = ["bash", "-c"]
#     command     = "az aks get-credentials --resource-group b2e1-gr2 --name b2e1-gr2-aks -f ~/.kube/config --overwrite-existing"
#   }
# }

# resource "null_resource" "manifest" {
#   depends_on = [module.helm, null_resource.get_credentials]
#   provisioner "local-exec" {
#     working_dir = "${path.root}/manifest/"
#     interpreter = ["bash", "-c"]
#     command     = "kubectl apply -f grafana.yml"
#   }
# }

# resource "grafana_data_source" "prometheus" {
#   depends_on = [null_resource.manifest]
#   type = "prometheus"
#   name = "prometheus"
#   url  = "http://prometheus-server.monitoring.svc.cluster.local"
# }

# resource "grafana_dashboard" "main" {
#   depends_on = [null_resource.manifest]
#   config_json = file("./dashboards/Node_Exporter.json")
# }