variable "resource_group" {
  type        = string
  description = "(Required) The name of the resource group in which to create the virtual network."
  nullable    = false
}

variable "location" {
  type        = string
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
  nullable    = false
}