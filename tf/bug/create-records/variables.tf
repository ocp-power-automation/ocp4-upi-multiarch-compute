################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

variable "ibmcloud_api_key" {
  description = "IBM Cloud API key"
  type        = string
  sensitive   = true
}

variable "ibmcloud_region" {
  description = "IBM Cloud region"
  type        = string
}

variable "ibmcloud_zone" {
  description = "IBM Cloud zone"
  type        = string
}

variable "ibm_cloud_cis_crn" {
  description = "IBM Cloud Internet Services (CIS) CRN"
  type        = string
}

variable "cluster_domain" {
  description = "The domain name for the cluster"
  type        = string
}
