### tasks/ignition.yml

The task downloads the ignition and sets up the preferred ignition, so it merges correctly with the downloaded ignition.

### tasks/patch-nfs-deployment-for-mac-worker.yml

The task patches the nfs deployment to the latest and pushes the work onto the Power workers.

### tasks/create_centos_image.yml

The task downloads locally the Centos Stream image, and then uploads the image to OpenStack.

### tasks/create_rhcos_image.yml

The task downloads locally the RHCOS image, and then uploads the image to OpenStack.

### tasks/remove_centos_image.yml

The task removes the centos_image from OpenStack.

### tasks/remove_rhcos_image.yml

The task removes the rhcos image from OpenStack.

### tasks/create_flavor.yml

The task creates the cpu/ram flavor on OpenStack that aligns with supported worker sizes.

### tasks/remove_flavor.yml

The task removes the custom cpu/ram flavor on OpenStack.

### tasks/create_vm_instance.yml

The task create virtual machine on OpenStack.

### tasks/delete_vm_instance.yml

The task removes virtual machine on OpenStack.

### tasks/vm_server_action.yml

The task start/stop/restart virtual machine on OpenStack.

### tasks/create_host_aggregate.yml

The task create a list of host aggregate (host group) on OpenStack.

### tasks/remove_host_aggregate.yml

The task removes host aggregate (host group) on OpenStack.

### tasks/patch-co-ingress-for-mac-worker.yml

The task patches the ingress to run on the primary architecture of the cluster. In this case, it's ppc64le.

### tasks/update-chrony-configuration.yml

The task updates the chrony.cfg based on subnet list on Bastion.
