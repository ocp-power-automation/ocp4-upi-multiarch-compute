# IBM Cloud CIS DNS Record Creation

This Terraform module creates DNS records in IBM Cloud Internet Services (CIS) for testing purposes.

## Overview

This module demonstrates how to:
- Configure the IBM Cloud provider
- Access an existing CIS domain
- Create DNS A records in CIS

## Prerequisites

- IBM Cloud account
- IBM Cloud Internet Services (CIS) instance
- Domain registered and configured in CIS
- IBM Cloud API key with appropriate permissions

## Required Variables

| Variable | Description | Type | Required |
|----------|-------------|------|----------|
| `ibmcloud_api_key` | IBM Cloud API key | string | Yes |
| `ibmcloud_region` | IBM Cloud region (e.g., us-south) | string | Yes |
| `ibmcloud_zone` | IBM Cloud zone (e.g., us-south-1) | string | Yes |
| `ibm_cloud_cis_crn` | IBM Cloud Internet Services CRN | string | Yes |
| `cluster_domain` | Domain name registered in CIS | string | Yes |

## Usage

1. **Copy the sample variables file:**
   ```bash
   cp var.tfvars.example var.tfvars
   ```

2. **Edit `var.tfvars` with your values:**
   ```hcl
   ibmcloud_api_key  = "your-api-key"
   ibmcloud_region   = "us-south"
   ibmcloud_zone     = "us-south-1"
   ibm_cloud_cis_crn = "crn:v1:bluemix:public:internet-svcs:global:a/..."
   cluster_domain    = "example.com"
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the plan:**
   ```bash
   terraform plan -var-file=var.tfvars
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply -var-file=var.tfvars
   ```

## Resources Created

- **DNS A Record**: A test DNS record pointing to 172.27.10.1 with hostname "test-random"

## Getting IBM Cloud Credentials

### API Key
1. Log in to [IBM Cloud Console](https://cloud.ibm.com)
2. Navigate to **Manage** → **Access (IAM)** → **API keys**
3. Click **Create an IBM Cloud API key**
4. Save the API key securely

### CIS CRN
1. Navigate to your CIS instance in IBM Cloud Console
2. Go to **Overview** tab
3. Copy the **CRN** value

### Region and Zone
- Common regions: `us-south`, `us-east`, `eu-gb`, `eu-de`, `jp-tok`, `au-syd`
- Zones are region-specific: `us-south-1`, `us-south-2`, `us-south-3`, etc.

## Cleanup

To remove all created resources:
```bash
terraform destroy -var-file=var.tfvars
```

## Files

- `cis.tf` - Main Terraform configuration for CIS DNS records
- `variables.tf` - Variable definitions
- `var.tfvars` - Sample variable values (copy and customize)
- `versions.tf` - Terraform and provider version constraints
- `outputs.tf` - Output definitions

## Security Notes

- Never commit `var.tfvars` with real credentials to version control
- Add `var.tfvars` to `.gitignore`
- Use environment variables or secure secret management for production
- The `ibmcloud_api_key` variable is marked as sensitive

## License

```
Copyright 2025 - IBM Corporation. All rights reserved  
SPDX-License-Identifier: Apache-2.0
```