variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group."
  nullable    = false
}

variable "subscription_id" {
  type        = string
  description = "(Required) The subscription id."
  nullable    = false
}

# ---------------------------------------------------------------------------------
# Prometheus
variable "prometheus_chart" {
  type        = string
  description = "(Required) The chart of prometheus."
  nullable    = false
}

variable "prometheus_name" {
  type        = string
  description = "(Required) The name of prometheus in resource helm."
  nullable    = false
}

variable "prometheus_namespace_creation" {
  type        = bool
  description = "(Required) Creation of the namaspace for prometheus."
  nullable    = false
  default     = true
}

variable "prometheus_namespace" {
  type        = string
  description = "(Required) The namespace of prometheus in resource helm."
  nullable    = false
}

variable "prometheus_repository" {
  type        = string
  description = "(Required) The repository of prometheus in resource helm."
  nullable    = false
}
# ---------------------------------------------------------------------------------
# Grafana
variable "grafana_chart" {
  type        = string
  description = "(Required) The chart of grafana."
  nullable    = false
}

variable "grafana_name" {
  type        = string
  description = "(Required) The name of grafana in resource helm."
  nullable    = false
}

variable "grafana_namespace" {
  type        = string
  description = "(Required) The namespace of grafana in resource helm."
  nullable    = false
}

variable "grafana_repository" {
  type        = string
  description = "(Required) The repository of grafana in resource helm."
  nullable    = false
}
# ---------------------------------------------------------------------------------
# Ingress
variable "ingress_chart" {
  type        = string
  description = "(Required) The chart of ingress."
  nullable    = false
}

variable "ingress_name" {
  type        = string
  description = "(Required) The name of ingress in resource helm."
  nullable    = false
}

variable "ingress_namespace_creation" {
  type        = bool
  description = "(Required) Creation of the namaspace for ingress."
  nullable    = false
  default     = true
}

variable "ingress_namespace" {
  type        = string
  description = "(Required) The namespace of ingress in resource helm."
  nullable    = false
}

variable "ingress_repository" {
  type        = string
  description = "(Required) The repository of ingress in resource helm."
  nullable    = false
}

variable "gateway_name" {
  type        = string
  description = "(Required) The name of the gateway."
  nullable    = false
}