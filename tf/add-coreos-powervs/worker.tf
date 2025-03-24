################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.powervs_region
  zone             = var.powervs_zone
}

resource "ibm_pi_instance" "worker" {
  count = 1

  pi_cloud_instance_id = var.powervs_service_instance_id
  pi_instance_name     = "${var.name_prefix}-worker-${count.index}"

  pi_sys_type   = var.system_type
  pi_proc_type  = var.processor_type
  pi_memory     = var.worker["memory"]
  pi_processors = var.worker["processors"]
  pi_image_id   = var.rhcos_image_id

  pi_key_pair_name = var.public_key_name
  pi_health_status = "WARNING"

  pi_network {
    network_id = "f2c7af53-22eb-48b4-b70c-d18f2f705d72"
  }

  ### DEV NOTE
  # need a different worker.ign with static ip setting a kernel arg using ignition following this pattern:
  # ip={{ item.ipaddr }}::{{ static_ip.gateway }}:{{ static_ip.netmask }}:{{ infraID.stdout }}-{{ item.name }}:ens192:off:{{ coredns_vm.ipaddr }}
  pi_user_data = base64encode(
    templatefile(
      "${path.cwd}/templates/worker.ign",
      {
        name : base64encode("${var.name_prefix}-worker-${count.index}"),
  }))
}
