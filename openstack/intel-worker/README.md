# Intel Worker Playbook: Getting Started Guide

* To Add the intel worker to power based ocp cluster use yml file from the playbook folder - `intel-worker-add-playbook.yml`

* To cleanup the intel worker use yml file from the playbook folder - `intel-worker-cleanup-playbook.yml`

``` Note: 
Update the variables for virtual machine. Below are the mandatory variables to be updated according to the opnstack environment.

Mandatory variables required. which are available in the playbook/roles/vm_create/defaults/main.yml
* vm_create_image_name 
* vm_create_flavor
* vm_create_availability_zone
* vm_create_bastion_ip

Note: Do not make changes vm_create_name, if its required to change the name,
      please do change in the vm_delete, vm_action, csr_approve, destroy_worker roles default respective varibales. 
```

## To Run the playbook use below commands

* To create a intel worker vm from openstack with ignition and add node to cluster with csr approve.
```
cd ocp4-upi-multiarch-compute/openstack/intel-worker/
ansible-playbook playbooks/intel-worker-add-playbook.yml -vvvv
```
* To cleanup the intel worker and delete the worker from openstack
```
cd ocp4-upi-multiarch-compute/openstack/intel-worker/
ansible-playbook playbooks/intel-worker-cleanup-playbook.yml -vvvv
```

### playbook/roles/vm_create/tasks/main.yml

The task create virtual machine on OpenStack. Also it will use the worker ignition at the time of OS boot. 

### playbook/roles/vm_delete/tasks/main.yml

The task removes virtual machine on OpenStack. also it will remove the intel worker node from the cluster.

### playbook/roles/vm_create/tasks/ignition.yml

The task downloads the ignition and sets up the preferred ignition, so it merges correctly with the downloaded ignition.

### playbook/roles/tasks/patch-nfs-deployment-for-mac-worker.yml

The task patches the nfs deployment to the latest and pushes the work onto the Power workers.

### playbook/roles/centos_create_image/tasks/main.yml

The task downloads locally the Centos Stream image, and then uploads the image to OpenStack.

### playbook/roles/rhcos_create_image_image/tasks/main.yml

The task downloads locally the RHCOS image, and then uploads the image to OpenStack.

### playbook/roles/centos_delete_image/tasks/main.yml

The task removes the centos_image from OpenStack.

### playbook/roles/rhcos_delete_image/tasks/main.yml

The task removes the rhcos image from OpenStack.

### playbook/roles/custom_flavor_create/tasks/main.yml

The task creates the cpu/ram flavor on OpenStack that aligns with supported worker sizes.

### playbook/roles/custom_flavor_delete/tasks/main.yml

The task removes the custom cpu/ram flavor on OpenStack.

### playbook/roles/vm_action/tasks/main.yml

The task start/stop/restart virtual machine on OpenStack. By providing the vm_action_name variable.

### playbook/roles/host_aggregate_create/tasks/main.yml

The task create a list of host aggregate (host group) on OpenStack.

### playbook/roles/host_aggregate_delete/tasks/main.yml

The task removes host aggregate (host group) on OpenStack.

### playbook/roles/patch-co-ingress-for-mac-worker.yml

The task patches the ingress to run on the primary architecture of the cluster. In this case, it's ppc64le.

### playbook/roles/update-chrony-configuration.yml

The task updates the chrony.cfg based on retrieved subnet list on Bastion.
The chrony.cfg is backed up to `/etc/chrony.conf.backup-SECONDS`, where SECONDS is the seconds since 1970-01-01.

### playbook/roles/update-chrony-configuration-in.yml

The task updates the chrony.cfg based on input subnet list on Bastion.
The chrony.cfg is backed up to `/etc/chrony.conf.backup-SECONDS`, where SECONDS is the seconds since 1970-01-01.
