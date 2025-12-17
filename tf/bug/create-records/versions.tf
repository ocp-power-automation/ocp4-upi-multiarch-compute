################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

terraform {
  required_providers {
    ibm = {
      source                = "IBM-Cloud/ibm"
      version               = "~> 1.85.0"
    }
  }
  required_version = ">= 1.5.0"
}


