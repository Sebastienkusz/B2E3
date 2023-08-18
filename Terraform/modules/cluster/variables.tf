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
  type        = string
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  nullable    = false
  default     = "Dynamic"
}

variable "domain_name_label" {
  type        = string
  description = "(Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system"
}

variable "public_ip_sku" {
  type        = string
  description = "(Optional) The SKU of the Public IP. Accepted values are Basic and Standard"
  default     = "Basic"
}

variable "subnet_id" {
  type        = string
  description = "(Required) Application gateway subnet ID"
  nullable    = false
}

variable "vm_size" {
  type        = string
  description = "(Required) The size of the virtual machine used to host Redis"
  nullable    = false
}

variable "pool_name" {
  type        = string
  description = "(Required) Name of the node pool"
  nullable    = false
}

variable "cluster_name" {
  type        = string
  description = "(Required) Name of the cluster"
  nullable    = false
}