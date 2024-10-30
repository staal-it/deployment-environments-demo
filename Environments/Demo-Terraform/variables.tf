variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "ade_env_name" {    
  description = "The name of the Azure Deployment environment."
  type        = string
}

variable "env_name" {
    description = "The name of the environment."
    type        = string
}

variable "ade_subscription" {
    description = "The Azure Deployment subscription."
    type        = string
}

variable "ade_location" {
    description = "The Azure Deployment location."
    type        = string
}

variable "ade_environment_type" {
    description = "The Azure Deployment environment type."
    type        = string
}