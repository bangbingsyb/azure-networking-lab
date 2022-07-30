variable "prefix" {
  type        = string
  description = "The prefix used for all resources in this example"
  default     = "n4a-tf"
}

variable "location" {
  type        = string
  description = "The Azure location where all resources in this example should be created"
  default     = "eastus2"
}
