variable "rg_name" {
  type        = string
  description = "Name of the resource group where Private DNS Zone will be deployed."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Specifies the supported Azure location where the resource exists."
}

variable "vnet_id" {
  type        = string
  description = "Virtual Network ID for DNS zone linking."
}

variable "private_dns_zone_name" {
  type        = string
  description = "DNS zone name you want to link to your Virtual Network."
}
