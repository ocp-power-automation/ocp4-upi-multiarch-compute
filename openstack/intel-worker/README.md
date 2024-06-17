# Intel Worker Playbook: Getting Started Guide

### Prerequisites:
* OCP cluster has to be in `multi` payload. If its not in `multi` payload the worker will not get added to power based ocp cluster.
* Here is the details of upgrading to multi payload [link](https://docs.openshift.com/container-platform/4.15/updating/updating_a_cluster/migrating-to-multi-payload.html#migrating-to-multi-payload)
* ```oc adm upgrade --to-multi-arch```

## Add the intel worker to power based ocp cluster 

* Use yml file from the playbook folder - `intel-worker-create-add-playbook.yml` to add the worker to power based cluster.

``` Note: 
Update the variables for virtual machine. Below are the mandatory variables to be updated according to the opnstack environment.

Mandatory variables required. which are available in the playbook/roles/vm_create/defaults/main.yml
* vm_create_image_name 
* vm_create_flavor
* vm_create_availability_zone
* vm_create_bastion_ip

Note: Do not make changes to vm_create_name, if its required to change the name,
      please do change in the vm_delete, vm_action, csr_approve, destroy_worker roles default respective varibales.
      which are find in the location below
      * playbook/roles/vm_create/defaults/main.yml
      * playbook/roles/csr_approve/defaults/main.yml
      * playbook/roles/vm_delete/defaults/main.yml
      * playbook/roles/destroy_worker/defaults/main.yml

      Also make sure the varibale in the vm_create vm_create_worker_hostname should match the csr_approve of csr_approve_intel_prefix
      and csr_approve_intel_zone as shown example below: 

      playbook/roles/vm_create/defaults/main.yml
            vm_create_worker_hostname: "rdr-mac-worker-openstack"

      playbook/roles/csr_approve/defaults/main.yml
            csr_approve_intel_prefix: "rdr-mac"
            csr_approve_intel_zone: "openstack"
      
```

* To create a intel worker vm from openstack with ignition and add node to cluster with csr approve.
```
cd ocp4-upi-multiarch-compute/openstack/intel-worker/
ansible-playbook playbooks/intel-worker-create-add-playbook.yml -vvvv
```

## To create the image and flavor 

* If there is no pre configured resources like image and flavor are present in the environment.
  Then use `intel-worker-create-image-flavor-playbook.yml` playbook.  
```
cd ocp4-upi-multiarch-compute/openstack/intel-worker/
ansible-playbook playbooks/intel-worker-create-image-flavor-playbook.yml -vvvv
```      

* If image and flavor are already available on the environment just updated the variable `vm_create_image_name` and `vm_create_flavor` in   `playbook/roles/vm_create/defaults/main.yml` file.
   

## To cleanup Run the playbook.

* To cleanup the intel worker and delete the worker from openstack.
```
cd ocp4-upi-multiarch-compute/openstack/intel-worker/
ansible-playbook playbooks/intel-worker-cleanup-playbook.yml -vvvv
```

* To cleanup the image and flavor which user has created from openstack.
  
```
cd ocp4-upi-multiarch-compute/openstack/intel-worker/
ansible-playbook playbooks/intel-worker-cleanup-image-flavor-playbook.yml -vvvv
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
