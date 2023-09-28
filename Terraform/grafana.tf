# resource "grafana_data_source" "prometheus" {
#   type = "prometheus"
#   name = "prometheus"
#   url  = "http://prometheus-server.monitoring.svc.cluster.local"
# }

# resource "grafana_dashboard" "main" {
#   config_json = file("./dashboards/Node_Exporter.json")
# }