################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

output "compute_ip" {
  value = [for index, s in openstack_networking_port_v2.worker_port : "${var.power_worker_prefix}-${index}: ${s.all_fixed_ips[0]}"]
}

output "helper_ip" {
  value = openstack_networking_port_v2.helper_port.all_fixed_ips[0]
}

output "add_these_to_chrony_allow" {
  description = "Add these values to your chrony.conf"
  value       = "\nAdd an allow rule for your Power worker subnet\n"
}
