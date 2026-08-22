# Deploy and connect K3S to Azure Arc

## Install K3S
Use the official quick start guide: https://docs.k3s.io/quick-start

## Create service principal in Azure Arc
Go to Azure Arc –> Additional Setup -> Service Principals
Save the App ID and Secret to a save location. We will need it for the script later.

## Register Resource Providers on Subscription
Make sure to register the following resource providers on the subscription where the Azure Arc Kubernetes resource will be created.
1. Microsoft.Kubernetes
2. Microsoft.KubernetesConfiguration
3. Microsoft.ExtendedLocation

