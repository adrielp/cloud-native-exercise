variable "vnet_name" {
  description = "The virtual net name"
  type        = string
  default     = "demo-vnet"
}

variable "resource_group_name" {
  description = "The resource group name"
  type        = string
  default     = "azureResourceGroup"
}

variable "location" {
  description = "Azure provider datacenter location"
  type        = string
  default     = "centralus"
}

variable "vnet_address_space" {
  description = "CIDR address space for the virtual network."
  type        = list(any)
  default     = ["10.0.0.0/16"]
}

variable "vm_size" {
  description = "VM size name for the provider"
  type        = string
  nullable    = false
}
