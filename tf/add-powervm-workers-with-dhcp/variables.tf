################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
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

variable "ignition_ip" {
  type        = string
  description = "The IP to retrieve the ignition file"
  default     = ""
}

variable "resolver_ip" {
  type        = string
  description = "The DNS resolver"
  default     = ""
}

variable "resolver_domain" {
  type        = string
  description = "The DNS Domain"
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

variable "image_id" {
  type        = string
  description = "image id from the PowerVC console"
  default     = ""
}

variable "worker_count" {
  type        = number
  description = "the number of workers to create"
  default     = 1
}

###### 
variable "rhel_username" {
  type        = string
  description = "The rhel username"
  default     = "root"
}

variable "ssh_agent" {
  description = "Enable or disable SSH Agent. Can correct some connectivity issues. Default: false"
  default     = false
}

variable "connection_timeout" {
  description = "Timeout in minutes for SSH connections"
  default     = 45
}

variable "public_key_file" {
  type        = string
  description = "Path to public key file"
  default     = "data/id_rsa.pub"
  # if empty, will default to ${path.cwd}/data/id_rsa.pub
}

variable "private_key_file" {
  type        = string
  description = "Path to private key file"
  default     = "data/id_rsa"
  # if empty, will default to ${path.cwd}/data/id_rsa
}

variable "helper" {
  default = {
    count         = 1
    instance_type = "tiny"
    image_id      = "b37ea741-8bd9-49e8-be88-7874016d9108"
    # cb1e8e75-3e80-49e8-aae2-79f873fab8f4
  }
}