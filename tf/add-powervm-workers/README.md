# Add PowerVM workers to Intel cluster

User need to update required vales in var.tfvars file such as username and password of IBM intranet credentials to get access to the PowerVC.

*Note* It is recommended to copy the var.tfvars into data/ and use the data/var.tfvars with your terraform commands.
```
auth_url                    = "https://host.net:5000/v3/"
user_name                   = "***@ibm.com"
password                    = "***"
```

If you are using a selinux enabled bastion, please set `chcon -R -t httpd_sys_content_t /var/www/html/ignition/worker.ign` where worker.ign is the file for the latest ignition.

### Use Terraform command to plan and apply .

``` shell
terraform plan -var-file=data/var.tfvars
```

``` shell
terraform apply -var-file=data/var.tfvars
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

### Ignition failed.

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

### Ignition successful, CSR does not show

* If you see the error with `no such host` error in the `sudo journalctl -u kubelet` add the DNS service points to the right host/ip of the ignition IP.
* Using the IBM Cloud Internet Service or IBM Cloud DNS Service [link](https://cloud.ibm.com/internet-svcs/), add a new record to resolve the IP which points to domain.
* Reboot the worker node to flush the dns cache to resolve the DNS and CSR will appear for the approval. once CSR are approved worker will get added to cluster.

