variable "name" {
  type        = string
  description = "Name of API Management instance"
}

variable "location" {
  type        = string
  description = "Location of the API Management instance"
}

variable "rg_name" {
  type        = string
  description = "Name of resource group in which to create API Managment instance"
}

variable "publisher_name" {
  type        = string
  description = "Name of administration of API Management instance"
}

variable "publisher_email" {
  type        = string
  description = "Email of administrator of API Managment instance that receives system notifications "
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to integrate API Management app and VNet"
}

