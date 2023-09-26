# Prometheus
variable "prometheus_chart" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "prometheus_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "prometheus_namespace_creation" {
  type        = bool
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
  default     = true
}

variable "prometheus_namespace" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "prometheus_repository" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

# Grafana
variable "grafana_chart" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "grafana_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "grafana_namespace" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "grafana_repository" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}