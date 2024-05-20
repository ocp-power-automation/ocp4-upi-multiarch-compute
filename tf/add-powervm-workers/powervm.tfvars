################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

auth_url    = "https://<PowerVC-Host>:5000/v3/"
user_name   = "<EMAIL>"
password    = "<PASSWORD>"
insecure    = true
tenant_name = "<PROJECT>"
domain_name = "<DOMAIN>"

network_name                = "<NETWORK>"
ignition_ip                 = "<IP>"
resolver_ip                 = "<IP>"
resolve_domain              = "<domain for resolver dns>"
power_worker_prefix         = "<prefix-for-power-workers>"
flavor_id                   = "<flavor_id>"
image_id                    = "<image_id>"
openstack_availability_zone = "<host group>"

# the number of workers to create
worker_count = 2
