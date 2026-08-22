# Deploy and connect K3S to Azure Arc


## Install K3S on Linux server
Use the official quick start guide: https://docs.k3s.io/quick-start. I personally used Ubuntu server 22.04 LTS.


## Create service principal in Azure Arc
Go to Azure Arc –> Additional Setup -> Service Principals. Save the App ID and Secret to a save location. We will need it for the script later.


## Register Resource Providers on Subscription
Make sure to register the following resource providers on the subscription where the Azure Arc Kubernetes resource will be created.
- Microsoft.Kubernetes
- Microsoft.KubernetesConfiguration
- Microsoft.ExtendedLocation


## Create Resource Group
Only necessary if a resource group doesn't exist.


## Download Script to Linux server
wget https://raw.githubusercontent.com/sukster/azure-arc-k3s/refs/heads/main/az_connect_k3s.sh

Make sure to update the environment variables in the script.


## Run the script on K3S server
Run the script as a regular user (not with sudo). Alternatively run each script line as a regular user separately in the shell.

./az_connect_K3S.sh
