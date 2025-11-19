################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

output "worker_ips" {
  value = openstack_compute_instance_v2.worker.*.access_ip_v4
}

output "worker_names" {
  value = openstack_compute_instance_v2.worker.*.name
}

output "worker_volumes" {
  value       = openstack_blockstorage_volume_v3.worker_volume.*.id
  description = "IDs of the created blank volumes"
}