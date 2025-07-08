################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.2.0"
    }
  }
  required_version = ">= 1.5.0"
}


