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

if [ "0" -eq "${INTEL_COUNT}" ]
then
  echo "There are no workers in the ${INTEL_ZONE}"
  exit 0
fi

IDX=0
READY_COUNT=$(oc get nodes -l kubernetes.io/arch=amd64 | grep "${MACHINE_PREFIX}" | grep -v NotReady | grep -c Ready)
while [ "${READY_COUNT}" -ne "${INTEL_COUNT}" ]
do

  echo "List of Intel Workers in ${INTEL_ZONE}: "
  oc get nodes -l 'kubernetes.io/arch=amd64' -o json | jq -r '.items[] | .metadata.name'
  echo ""

  echo "Approve and Issue - #${IDX}"
  echo "List of Intel Workers to be added with prefix '${MACHINE_PREFIX}': "
  oc get nodes -l 'kubernetes.io/arch=amd64' --no-headers=true | grep "${MACHINE_PREFIX}"
  echo ""

  # Approve
  JSON_BODY=$(oc get csr -o json | jq -r '.items[] | select (.spec.username == "system:serviceaccount:openshift-machine-config-operator:node-bootstrapper")' | jq -r '. | select(.status == {})')
  for CSR_REQUEST in $(echo ${JSON_BODY} | jq -r '. | "\(.metadata.name),\(.spec.request)"')
  do 
    CSR_NAME=$(echo ${CSR_REQUEST} | sed 's|,| |'| awk '{print $1}')
    CSR_REQU=$(echo ${CSR_REQUEST} | sed 's|,| |'| awk '{print $2}')
    echo "CSR_NAME: ${CSR_NAME}"
    NODE_NAME=$(echo ${CSR_REQU} | base64 -d | openssl req -text | grep 'Subject:' | awk '{print $NF}')
    echo "Pending CSR found for NODE_NAME: ${NODE_NAME}"

    if grep -q "system:node:${MACHINE_PREFIX}-" <<< "$NODE_NAME"
    then
      oc adm certificate approve "${CSR_NAME}"
    fi
  done

  LOCAL_WORKER_SCAN=0
  while [ "$LOCAL_WORKER_SCAN" -lt "$INTEL_COUNT" ]
  do
    # username: system:node:mac-674e-worker-0
    for CSR_NAME in $(oc get csr -o json | jq -r '.items[] | select (.spec.username == "'system:node:${MACHINE_PREFIX}-${LOCAL_WORKER_SCAN}'")' | jq -r '.metadata.name')
    do
      # Dev note: will approve more than one matching csr
      echo "Approving: ${CSR_NAME} system:node:${MACHINE_PREFIX}-${LOCAL_WORKER_SCAN}"
      oc adm certificate approve "${CSR_NAME}"
    done
    sleep 10
    LOCAL_WORKER_SCAN=$(($LOCAL_WORKER_SCAN + 1))
  done

  # Wait for 30 seconds before we hammer the system
  echo "Sleeping before re-running - 30 seconds"
  sleep 30

  # Re-read the 'Ready' count
  READY_COUNT=$(oc get nodes -l kubernetes.io/arch=amd64 | grep "${MACHINE_PREFIX}" | grep -v NotReady | grep -c Ready)

  # Increment counter
  IDX=$(($IDX + 1))

  # End Early... we've checked enough.
  if [ "${IDX}" -eq "60" ]
  then
    echo "Exceeded the wait time for CSRs to be generated - > 30 minutes"
    echo "Printing all Nodes"
    oc get nodes -owide
    echo ""
    echo "Get All CSRs"
    oc get csr
    echo "Exiting with Error. Ready count - ${READY_COUNT} is not matching with expected Intel Worker count - ${INTEL_COUNT}"
    echo "Supplied Worker/s with prefix: '${MACHINE_PREFIX}' are not yet Ready."
    exit -1
  fi
done
# Final Check
if [ "${READY_COUNT}" -eq "${INTEL_COUNT}" ]
then
  echo "Supplied Worker/s with prefix: '${MACHINE_PREFIX}' are Ready."
  oc get nodes -l 'kubernetes.io/arch=amd64' --no-headers=true | grep "${MACHINE_PREFIX}"
fi