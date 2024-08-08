################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

output "approve_the_csr" {
  value = "You now need to approve the nodes for your cluster. `oc get csr -oname | xargs oc adm certificate approve`"
}