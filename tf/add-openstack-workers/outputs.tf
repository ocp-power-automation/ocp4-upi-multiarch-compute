################################################################
# Copyright 2023 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

output "dhcp" {
  value = data.openstack_networking_subnet_v2.subnet
}