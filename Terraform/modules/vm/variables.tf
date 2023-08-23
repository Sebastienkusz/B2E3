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

variable "vm_size" {
  type        = string
  description = "(Required) The size of the virtual machine used to host Redis"
  nullable    = false
}

variable "os_disk_caching" {
  type        = string
  description = "(Optional) Specifies the caching requirements for the OS Disk. Possible values include None, ReadOnly and ReadWrite"
}

variable "os_disk_create_option" {
  type        = string
  description = "(Required) Specifies how the OS Disk should be created. Possible values are Attach (managed disks only) and FromImage"
  nullable    = false
  default     = "FromImage"
}

variable "os_disk_managed_disk_type" {
  type        = string
  description = "(Optional) Specifies the type of Managed Disk which should be created. Possible values are Standard_LRS, StandardSSD_LRS or Premium_LRS"
}

variable "image_publisher" {
  type        = string
  description = "(Optional) Specifies the publisher of the image used to create the virtual machine. Changing this forces a new resource to be created."
}

variable "image_offer" {
  type        = string
  description = "(Optional) Specifies the offer of the image used to create the virtual machine. Changing this forces a new resource to be created"
}

variable "image_sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the image used to create the virtual machine. Changing this forces a new resource to be created"
}

variable "image_version" {
  type        = string
  description = "(Optional) Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created"
}

variable "admin_username" {
  type        = string
  description = "(Required) Specifies the name of the local administrator account"
  nullable    = false
  default     = "adminuser"
}

variable "path" {
  type        = string
  description = "(Required) The path of the destination file on the virtual machine"
  nullable    = false
  default     = "/home/adminuser/.ssh/authorized_keys"
}

variable "ssh_key" {
  type        = string
  description = "(Required) The Public SSH Key which should be written to the path defined above."
  nullable    = false
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
  description = "(Required) VM subnet ID"
  nullable    = false
}

variable "ssh_port" {
  type        = string
  description = "SSH Port"
  nullable    = false
  default     = "22"
}

variable "ssh_ip_filter" {
  type        = list
  description = "List of IP available to connect with ssh"
  nullable    = false
  default     = []
}

variable "redis_port" {
  type        = string
  description = "Redis Port"
  nullable    = false
  default     = "6379"
}