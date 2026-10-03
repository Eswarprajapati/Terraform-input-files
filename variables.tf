variable "prefix" {
  type        = string
  description = "Lowercase alphanumeric project prefix used in Azure resource names."
  default     = "eswardata"
  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,11}$", var.prefix))
    error_message = "Use 3-12 lowercase alphanumeric characters, beginning with a letter."
  }
}
variable "location" {
  type        = string
  description = "Azure region for the demo resources."
  default     = "eastus"
}
variable "environment" {
  type        = string
  description = "Environment label."
  default     = "dev"
  validation {
    condition     = contains(["dev", "test"], var.environment)
    error_message = "This demonstration supports dev or test environments."
  }
}
