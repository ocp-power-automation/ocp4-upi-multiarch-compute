#!/usr/bin/env bash

################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

# Approve and Issue CSRs for our generated amd64 workers only
# The hostname is of the style - ${name_prefix}-worker-${ZONE}-${index}

# Var: ${self.triggers.counts}
INTEL_COUNT="${1}"

# Var: ${self.triggers.approve}
INTEL_PREFIX="${2}"

INTEL_ZONE="${3}"

# Machine Prefix
MACHINE_PREFIX="${INTEL_PREFIX}-worker-${INTEL_ZONE}"

IDX=0
while [ "$IDX" -lt "$INTEL_COUNT" ]
do
    echo "Removing the Worker Zone ${INTEL_ZONE}: ${MACHINE_PREFIX}-${IDX}"
    oc delete node ${MACHINE_PREFIX}-${IDX} || true
    IDX=$(($IDX + 1))
done