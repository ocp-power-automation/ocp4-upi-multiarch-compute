################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

variable "user_name" {
  description = "The user name used to connect to OpenStack/PowerVC"
  default     = "my_user_name"
}

variable "password" {
  description = "The password for the user"
  default     = "my_password"
}

variable "tenant_name" {
  description = "The name of the project (a.k.a. tenant) used"
  default     = "ibm-default"
}

variable "domain_name" {
  description = "The domain to be used"
  default     = "Default"
}

variable "auth_url" {
  description = "The endpoint URL used to connect to OpenStack/PowerVC"
  default     = "https://<HOSTNAME>:5000/v3/"
}

variable "insecure" {
  default = "true" # OS_INSECURE
}

variable "openstack_availability_zone" {
  description = "The name of Availability Zone for deploy operation"
  default     = ""
}

################################################################
# 

variable "network_name" {
  type        = string
  description = "The Network Name in OpenStack"
  default     = ""
}

variable "power_worker_prefix" {
  type        = string
  description = "The power worker prefixes"
  default     = ""
}

variable "flavor_id" {
  type        = string
  description = "flavor id from the PowerVC console"
  default     = ""
}

# Volume-related variables
variable "volume_size" {
  type        = number
  description = "Size of the blank volume in GB"
  default     = 500
}

variable "volume_type" {
  type        = string
  description = "Type of volume to create"
  default     = ""
}

variable "worker_count" {
  type        = number
  description = "the number of workers to create"
  default     = 1
}