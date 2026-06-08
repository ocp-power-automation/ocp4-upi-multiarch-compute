# Add PowerVM Workers to OpenShift Cluster with Automated DHCP

This Terraform module deploys PowerVM workers to an existing OpenShift cluster with automated DHCP configuration using a helper VM.

## Overview

This module creates:
- **Helper VM**: A RHEL-based VM that runs dnsmasq (DHCP/DNS) and httpd to serve ignition files
- **PowerVM Worker Nodes**: One or more RHCOS worker nodes that boot via the helper VM's DHCP service

The helper VM automatically:
- Configures dnsmasq with DHCP reservations for each worker
- Downloads the worker ignition file from the OpenShift API server
- Serves the ignition file via HTTP for worker bootstrapping

## Prerequisites

- Existing OpenShift cluster with accessible API endpoint
- PowerVC/OpenStack environment with:
  - Network connectivity to OpenShift cluster
  - RHCOS image uploaded
  - RHEL image for helper VM (default: `b37ea741-8bd9-49e8-be88-7874016d9108`)
- SSH key pair for helper VM access
- OpenStack/PowerVC credentials

## Configuration

### Required Variables

Create a `data/var.tfvars` file with the following variables:

```hcl
# OpenStack/PowerVC Authentication
auth_url     = "https://<POWERVC_HOST>:5000/v3/"
user_name    = "your_username@example.com"
password     = "your_password"
tenant_name  = "ibm-default"
domain_name  = "Default"

# Network Configuration
network_name      = "your-network-name"
ignition_ip       = "10.x.x.x"  # OpenShift API server IP (for ignition download)
resolver_ip       = "10.x.x.x"  # DNS server IP
resolver_domain   = "example.com"

# Worker Configuration
power_worker_prefix = "worker-ppc"
worker_count        = 2
flavor_id           = "your-flavor-id"
image_id            = "your-rhcos-image-id"

# SSH Keys (for helper VM)
public_key_file  = "data/id_rsa.pub"
private_key_file = "data/id_rsa"

# Optional: Availability Zone
openstack_availability_zone = ""
```

### Variable Details

| Variable | Description | Default |
|----------|-------------|---------|
| `auth_url` | PowerVC/OpenStack API endpoint | `https://<HOSTNAME>:5000/v3/` |
| `user_name` | PowerVC/OpenStack username | - |
| `password` | PowerVC/OpenStack password | - |
| `tenant_name` | Project/tenant name | `ibm-default` |
| `domain_name` | OpenStack domain | `Default` |
| `network_name` | Network name for worker nodes | - |
| `ignition_ip` | OpenShift API server IP (port 22623) | - |
| `resolver_ip` | DNS server IP address | - |
| `resolver_domain` | DNS search domain | - |
| `power_worker_prefix` | Prefix for worker node names | - |
| `worker_count` | Number of worker nodes to create | `1` |
| `flavor_id` | PowerVC flavor ID for workers | - |
| `image_id` | RHCOS image ID | - |
| `public_key_file` | Path to SSH public key | `data/id_rsa.pub` |
| `private_key_file` | Path to SSH private key | `data/id_rsa` |
| `helper.instance_type` | Helper VM flavor name | `tiny` |
| `helper.image_id` | RHEL image ID for helper VM | `b37ea741-8bd9-49e8-be88-7874016d9108` |

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Plan Deployment

```bash
terraform plan -var-file=data/var.tfvars
```

### 3. Apply Configuration

```bash
terraform apply -var-file=data/var.tfvars
```

### 4. Power On Workers

The worker VMs are created in a powered-off state. After Terraform completes:

1. Verify the helper VM is running and configured:
   ```bash
   # SSH to helper VM (IP shown in terraform output)
   ssh root@<helper_ip>
   
   # Verify dnsmasq is running
   systemctl status dnsmasq
   
   # Verify httpd is serving ignition file
   curl http://localhost/ignition/worker.ign
   ```

2. Power on the worker VMs via PowerVC console or CLI

3. Workers will:
   - Obtain IP via DHCP from helper VM
   - Download ignition config from helper VM
   - Bootstrap and join the cluster

### 5. Approve CSRs

Monitor and approve Certificate Signing Requests:

```bash
# Watch for pending CSRs
watch oc get csr

# Approve pending CSRs
oc get csr -o name | xargs oc adm certificate approve
```

### 6. Verify Workers

```bash
# Check node status
oc get nodes

# Verify worker nodes are Ready
oc get nodes -l node-role.kubernetes.io/worker
```

## Outputs

After successful deployment, Terraform provides:

- `compute_ip`: List of worker node IPs and names
- `helper_ip`: Helper VM IP address
- `add_these_to_chrony_allow`: Reminder to configure chrony on bastion

## Architecture

```
┌─────────────────────┐
│  OpenShift Cluster  │
│   (API: 22623)      │
└──────────┬──────────┘
           │
           │ Ignition Download
           │
┌──────────▼──────────┐
│    Helper VM        │
│  ┌──────────────┐   │
│  │   dnsmasq    │   │ DHCP Server
│  │   (DHCP/DNS) │   │
│  └──────────────┘   │
│  ┌──────────────┐   │
│  │    httpd     │   │ Ignition Server
│  │   (port 80)  │   │
│  └──────────────┘   │
└──────────┬──────────┘
           │
           │ DHCP + Ignition
           │
┌──────────▼──────────┐
│  PowerVM Workers    │
│  ┌──────────────┐   │
│  │  worker-0    │   │
│  └──────────────┘   │
│  ┌──────────────┐   │
│  │  worker-1    │   │
│  └──────────────┘   │
└─────────────────────┘
```

## Troubleshooting

### Helper VM Issues

**Check helper VM services:**
```bash
ssh root@<helper_ip>

# Check dnsmasq
systemctl status dnsmasq
journalctl -u dnsmasq -f

# Check httpd
systemctl status httpd
journalctl -u httpd -f

# Verify ignition file
ls -la /var/www/html/ignition/
curl http://localhost/ignition/worker.ign
```

**Verify DHCP configuration:**
```bash
cat /etc/dnsmasq.conf
```

### Worker Boot Issues

**Check worker console in PowerVC:**
- Verify DHCP lease is obtained
- Check for ignition fetch errors

**Common ignition failures:**
```bash
# On worker console
systemctl --failed
journalctl -u ignition-fetch
journalctl -u ignition-mount
```

**Manual ignition stages:**
```bash
ignition --platform openstack --stage mount --log-to-stdout
ignition --platform openstack --stage fetch --log-to-stdout
```

### CSR Not Appearing

**Check kubelet logs on worker:**
```bash
sudo journalctl -u kubelet
```

**Common issues:**
- DNS resolution failure: Verify `resolver_ip` points to correct DNS server
- Network connectivity: Ensure worker can reach OpenShift API server
- Hostname mismatch: Check `/etc/hostname` on worker

**DNS troubleshooting:**
```bash
# On worker
cat /etc/resolv.conf
nslookup api.<cluster-domain>
```

### SELinux Issues (Bastion)

If using a SELinux-enabled bastion to serve ignition files:
```bash
chcon -R -t httpd_sys_content_t /var/www/html/ignition/worker.ign
```

### Network Issues

**Verify network connectivity:**
```bash
# From helper VM
ping <ignition_ip>
curl -k https://<ignition_ip>:22623/config/worker

# From worker (after boot)
ping <helper_ip>
curl http://<helper_ip>/ignition/worker.ign
```

## Cleanup

To remove all resources:

```bash
terraform destroy -var-file=data/var.tfvars
```

This will delete:
- All worker VMs
- Helper VM
- Network ports
- SSH keypair

## Notes

- Workers are initially created in powered-off state for safety
- Helper VM automatically configures DHCP with MAC-to-IP mappings
- Ignition file is fetched from OpenShift API server (port 22623)
- The helper VM serves ignition via HTTP on port 80
- Network dispatcher script disables tx-checksumming on worker network interfaces
- Default gateway is automatically configured via DHCP option

## Additional Configuration

### Chrony Configuration

Add the Power worker subnet to your chrony configuration on the bastion/time server:

```bash
# Edit /etc/chrony.conf
allow <worker_subnet>/24
```

### Custom Helper VM

To use a different RHEL image or flavor for the helper VM:

```hcl
helper = {
  count         = 1
  instance_type = "small"
  image_id      = "your-rhel-image-id"
}
```

## References

- [OpenShift UPI Documentation](https://docs.openshift.com/container-platform/latest/installing/installing_platform_agnostic/installing-platform-agnostic.html)
- [Ignition Configuration Specification](https://coreos.github.io/ignition/)
- [PowerVC Documentation](https://www.ibm.com/docs/en/powervc)
