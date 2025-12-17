################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.ibmcloud_region
  zone             = var.ibmcloud_zone
}

data "ibm_cis_domain" "domain" {
  cis_id = var.ibm_cloud_cis_crn
  domain = var.cluster_domain
}

resource "ibm_cis_dns_record" "bastion" {
  cis_id    = var.ibm_cloud_cis_crn
  content   = "172.27.10.1"
  domain_id = data.ibm_cis_domain.domain.id
  name      = "test-random"
  ttl       = 900
  type      = "A"
}