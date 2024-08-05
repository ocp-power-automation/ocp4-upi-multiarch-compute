################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

auth_url                    = "http://SERVER:5000/v3/"
user_name                   = "USERNANE"
password                    = "PASSWORD"
tenant_name                 = "TENANT_NAME"
domain_name                 = "Default"
openstack_availability_zone = "nova"

network_name = "provider"

worker      = { instance_type = "m1.xlarge", image_id = "IMAGE_UUID", "count" = 1 }
resolver_ip = "DNS_RESOLVER_IP"
ignition_ip = "IGNITION_IP"
prefix      = "debug"