################################################################
# Copyright 2023 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.1.0"
    }
  }
  required_version = ">= 1.5.0"
}


