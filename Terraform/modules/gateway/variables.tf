variable "resource_group" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  nullable    = false
  default     = "westeurope"
}

variable "public_ip_allocation_method" {
    type = string 
    description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic"
    nullable = false
    default = "Dynamic"
}

variable "domain_name_label" {
    type = string
    description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system"
}

variable "public_ip_sku" {
    type = string
    description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard"
    default = "Basic"
}

variable "name" {
  type = string
  description = "(Required) Names used for the Gateway"
  nullable = false
  default = "app-gateway"
}

variable "sku_name" {
  type = string
  description = "(Required) The Name of the SKU to use for this Application Gateway."
  nullable = false
  default = "Standard_v2"
}

variable "cookie_based_affinity" {
  type = string
  description = "(Required) Is Cookie-Based Affinity enabled? "
  nullable = false
}

variable "backend_port" {
  type = number
  description = "(Required) The port which should be used for this Backend HTTP Settings Collection."
  nullable = false
}

variable "backend_protocol" {
  type = string
  description = "(Required) The Protocol which should be used."
  nullable = false
}

variable "frontend_protocol" {
  type = string
  description = "(Required) The Protocol which should be used."
  nullable = false
}

variable "frontend_port" {
  type  = number
}
variable "rule_type" {
  type = string
  description = "(Required) The Type of Routing that should be used for this Rule."
  nullable = false
}

variable "tier" {
  type = string
  description = "Required) The Tier of the SKU to use for this Application Gateway"
  nullable = false
}