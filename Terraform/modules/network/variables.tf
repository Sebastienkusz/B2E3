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

variable "vnet_cidr" {
  type        = list(string)
  description = "(Required) The address space that is used by the virtual network. You can supply more than one address space."
  nullable    = false
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the virtual network."
  default     = {}
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "(Required) A list of address prefixes to use for the subnets."
  default     = []
}