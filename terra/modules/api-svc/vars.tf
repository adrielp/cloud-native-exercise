variable "vm_size" {
  description = "VM size name for the provider"
  type        = string

}

variable "helm_chart_local_path" {
  description = "Local helm chart path to api-svc"
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Resource group name for AKS"
  type        = string
}

variable "location" {
  description = "Region for Azure"
  type        = string
}
