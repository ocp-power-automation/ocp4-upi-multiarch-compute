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
