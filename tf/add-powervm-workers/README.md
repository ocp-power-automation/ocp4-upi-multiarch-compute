# Add PowerVM workers to Intel cluster

User need to uopdate required vales in data/vars.tfvars file such as username and password of IBM intranet credentials to get access to the PowerVC.
```
auth_url                    = "https://host.net:5000/v3/"
user_name                   = "***@us.ibm.com"
password                    = "***"
```

If you are using a selinux enabled bastion, please set `chcon -R -t httpd_sys_content_t /var/www/html/ignition/worker.ign` where worker.ign is the file for the latest ignition.

### Use Terraform command to plan and apply .

  ```
  terraform plan -var-file=data/powervm.tfvars
  ```

  ```
  terraform apply -var-file=data/powervm.tfvars
  ```

### Configure the DHCP and restart the dhcpd service.

Get the MAC Address and IP Address of the VM created on PowerVC. Update /etc/dhcp/dhcpd.conf with the lease/addresses as shown below.

  ```
  host workerp-0 { hardware ethernet fa:16:3e:0f:95:6b; fixed-address 10.20.177.243; }
  ```

* Restart the dhcpd.
  ```
  systemctl restart dhcpd
  ```
* Restart the Worker node for ignition to start.

* Approve the CSR certificate to add the worker to intel cluster.
  ```
  oc get csr
  ```
  ```
  oc adm certificate approve <certificate-name>
  ```



## Troubleshooting


### If Ignition failed.

* If ignition failed, Once you have the VM console, run the following commands:
```
systemctl --failed
journalctl -u ignition-fetch
```
2. Ignition happens in a couple of steps
```
ignition -platform openstack -stage mount -log-to-stdout
```
then fetch
```
ignition --platform openstack -stage fetch -log-to-stdout
```
```
sudo journalctl -u kubelet
```
* Ignition file properties should has `/etc/hostname` , `/etc/resolv.conf`, `passwd` section with proper values.



### Even after the ignition was sucessful , CSR didn't appear 

* If you see the error with `no such host` error in the `sudo journalctl -u kubelet` add the DNS service points to the right host/ip of the ignition IP.
* Using the dns service [link](https://cloud.ibm.com/internet-svcs/crn%3Av1%3Abluemix%3Apublic%3Ainternet-svcs%3Aglobal%3Aa%2F65b64c1f1c29460e8c2e4bbfbd893c2c%3A60ee139c-1c18-4728-a035-e34533b78a8b%3A%3A?paneId=reliability), Add a new record to resolve the IP which points to domain.
* Reboot the worker node to flush the dns cache to resolve the DNS and CSR will appear for the approval. once CSR are approved worker will get added to cluster.

