################################################################
# Copyright 2023 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

variable "user_name" {
  description = "The user name used to connect to OpenStack"
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

variable "network_name" {
  type        = string
  description = "The network name of the provider"
  default     = ""
}

variable "ignition_ip" {
  type        = string
  description = "The ip of the bastion"
  default     = ""
}

variable "resolver_ip" {
  type        = string
  description = "The ip of the dns resolver"
  default     = ""
}

variable "worker" {
  default = {
    count         = 1
    instance_type = "m1.xlarge"
    image_id      = "468863e6-4b33-4e8b-b2c5-c9ef9e6eedf4"
  }
}

variable "prefix" {
  type        = string
  description = "The prefix of the added machine"
  default     = "worker"
}