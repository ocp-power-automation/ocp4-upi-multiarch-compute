# Add PowerVM Workers with Blank Volume

This Terraform module creates PowerVM worker nodes with blank volumes instead of using ignition files. This is useful for scenarios where you want to manually configure the worker nodes or use a different provisioning method.

## Prerequisites

- OpenStack/PowerVC credentials
- Network configuration
- Flavor ID for the worker nodes
