variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "subscription_id" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

# ---------------------------------------------------------------------------------
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
# ---------------------------------------------------------------------------------
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
# ---------------------------------------------------------------------------------
# Ingress
variable "ingress_chart" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "ingress_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "ingress_namespace_creation" {
  type        = bool
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
  default     = true
}

variable "ingress_namespace" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "ingress_repository" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "gateway_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}