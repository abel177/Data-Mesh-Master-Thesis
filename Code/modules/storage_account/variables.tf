variable "rg_name" {
  type        = string
  description = "The name of the resource group for deployment."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists."
}

variable "prefix" {
  type        = string
  description = "The workload prefix, e.g. including department, general workload and environment."

  validation {
    condition     = length(var.prefix) <= 15
    error_message = "The length of the prefix can't be more than 10 characters."
  }
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
}

variable "name" {
  type    = string
  default = "sa"

  validation {
    condition     = length(var.name) <= 5
    error_message = "The length of the name can't be more than than 5 characters."
  }
}

variable "subnet_ids" {
  type    = list(any)
  default = []
}

variable "bypass" {
  type    = list(any)
  default = ["AzureServices"]
}

variable "network_default_action" {
  type    = string
  default = "Deny"
}

variable "ip_rules" {
  type    = list(any)
  default = []
}

variable "datalake_v2" {
  description = "Enabled Hierarchical name space for Data Lake Storage gen 2"
  type        = bool
  default     = false
}

variable "pe_subnet_id" {
  type = string
}
variable "pe_subresource_dns_zone_id" {
  type    = map(any)
  default = {}
}
