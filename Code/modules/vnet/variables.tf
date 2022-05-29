variable "rg_name" {
  description = "Name of the resource group for VNET."
  type        = string
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "name" {
  description = "Name of the vnet to create."
  type        = string
}

variable "prefix" {
  type        = string
  description = "The workload prefix, e.g. including department, general workload and environment"
}

variable "location" {
  description = "The location of the vnet to create."
  type        = string
  default     = "westeurope"
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
  default     = []
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
  default     = []
}

variable "subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
  default     = {}
}

variable "subnet_enforce_private_link_endpoint_network_policies" {
  description = "A map of subnet name to enable/disable private link endpoint network policies on the subnet."
  type        = map(bool)
  default     = {}
}

variable "subnet_enforce_private_link_service_network_policies" {
  description = "A map of subnet name to enable/disable private link service network policies on the subnet."
  type        = map(bool)
  default     = {}
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs."
  type        = map(string)
  default     = {}
}

variable "route_tables_ids" {
  description = "A map of subnet name to Route table ids."
  type        = map(string)
  default     = {}
}

variable "subnet_delegation" {
  description = "A map of subnet name to delegation block on the subnet."
  type        = map(map(any))
  default     = {}
}
