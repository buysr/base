# Ultimate and Secure Azure Bastion Guide

In this Ultimate and Secure Azure Bastion Guide you can find the required steps to enable Azure Bastion for both Linux as Windows. We do require Entra ID integration but also show you how to use local accounts (less secure).

## Azure Bastion Architecture

Below you can find the Architecture for Azure Bastion:

![https://learn.microsoft.com/en-us/azure/bastion/media/bastion-overview/architecture.png](./assets/architecture.png)

### Requirements

Requirements for Azure Bastion:

- Ensure you have an Azure subscription.
- RBAC Owner role on the subscription, with this we can assign the RBAC role Virtual Machine Administrator Login **OR** Virtual Machine User Login on the Virtual Machine we need to login to.
- A virtual network with a subnet named `AzureBastionSubnet` with a minimum of 32 IP addresses (e.g. /27).
- Network Security Group (NSG) rules to allow Bastion traffic.
- Virtual Machine must be running in the same region as the virtual network and Bastion host.

## Create Azure Bastion

We use Infra as Code for Azure Bastion.

### BICEP



### Terraform



## Connect to Azure Bastion

### RDP to Windows VM

We will use the Azure CLI. We will use the following command to connect to the Windows VM:

```powershell
# Login with the account that has the Virtual Machine Administrator Login or Virtual Machine User Login role assigned to the VM.
az login

# Set the subscription to the one where the Bastion host is deployed.
az account set --subscription <subscriptionid>

# Connect to the Bastion host using the Azure CLI.
az network bastion rdp --name <bastionhost> --resource-group <bastionresourcegroup> --target-resource-id <resourceidofvm> --enable-mfa
```



### SSH to Linux VM

We will use the Azure CLI. We will use the following command to connect to the Linux VM:

```powershell
# Install the SSH extension for Azure CLI if not already installed!
az extension add -n ssh

# Login with the account that has the Virtual Machine Administrator Login or Virtual Machine User Login role assigned to the VM.
az login

# Set the subscription to the one where the Bastion host is deployed.
az account set --subscription <subscriptionid>

# Connect to the Bastion host using the Azure CLI.
az network bastion ssh --name <bastionhost> --resource-group <bastionresourcegroup> --target-resource-id <resourceidofvm>
```
