################################################################
# Copyright 2023 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

# *Design Note*
# Global variables are prefixed with ibmcloud_
# PowerVS variables are prefixed with powervs_
# VPC variables are prefixed with vpc_

variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API key associated with user's identity"
  default     = "<key>"

  validation {
    condition     = var.ibmcloud_api_key != "<key>"
    error_message = "The api key is empty, check that the -var-file= is set properly"
  }
}

################################################################
# Configure the IBM PowerVS provider
################################################################

variable "powervs_service_instance_id" {
  type        = string
  description = "The PowerVS service instance ID of your account"
  default     = ""
}

variable "powervs_region" {
  type        = string
  description = "The IBM Cloud region where you want to create the workers"
  default     = ""
}

variable "powervs_zone" {
  type        = string
  description = "The zone of an IBM Cloud region where you want to create Power System workers"
  default     = ""
}

variable "processor_type" {
  type        = string
  description = "The type of processor mode (shared/dedicated)"
  default     = "shared"
}

# Reference https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-about-virtual-server
# The default is s922.
variable "system_type" {
  type        = string
  description = "The type of system (s922/e980/s1022/s1080)"
  default     = "s922"
}

variable "worker" {
  default = {
    count      = 1
    memory     = "16"
    processors = "1"
  }
  type        = object({ count = number, memory = string, processors = string })
  description = "The worker configuration details. You may have 0 or more workers"
  validation {
    condition     = lookup(var.worker, "count", 1) >= 0
    error_message = "The worker.count value must be greater than 0."
  }
  nullable = false
}

variable "name_prefix" {
  type    = string
  default = ""
  validation {
    condition     = length(var.name_prefix) <= 32
    error_message = "Length cannot exceed 32 characters for name_prefix."
  }
}

variable "rhcos_image_id" {
  type        = string
  description = "rhcos image id"
  default     = "rhcos-4.14"
}

variable "public_key_name" {
  type    = string
  default = "<none>"
}