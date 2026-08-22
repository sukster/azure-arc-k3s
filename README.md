# Deploy and connect K3S to Azure Arc


## Install K3S on Linux server
Use the official quick start guide: https://docs.k3s.io/quick-start. I tested this on Ubuntu server 22.04 LTS.


## Create service principal in Azure Arc
Go to Azure Arc –> Additional Setup -> Service Principals. For "Scope assignment level" select only the Resource Group. For "Roles" select:
- Azure Connected Machine Onboarding
- Kubernetes Cluster - Azure Arc Onboarding
<br>
Save the App ID and Secret to a save location. We will need it for the scripts later.


## Register Resource Providers on Subscription
Make sure to register the following resource providers on the subscription where the Azure Arc Kubernetes resource will be created.
- Microsoft.Kubernetes
- Microsoft.KubernetesConfiguration
- Microsoft.ExtendedLocation


## Create Resource Group
Only necessary if a resource group doesn't exist.


## Download onboarding script to K3S control plane server
```
wget https://raw.githubusercontent.com/sukster/azure-arc-k3s/refs/heads/main/az_connect_k3s.sh
```
Make sure to update the environment variables in the script.


## Run the script on K3S control plane server
Run the script as a regular user (not with sudo).
```
./az_connect_K3S.sh
```

## Enable Defender for Containers
Go to Azure -> Defender for Cloud -> Environment Settings -> Your Subscription and turn on Defender for Containers plan.


## Configure K3s audit logging
1. Create a directory for the audit logs:
```
sudo mkdir -p -m 700 /var/lib/rancher/k3s/server/logs
```
3. Create audit.yaml file and paste the following code in it:
```
sudo nano /var/lib/rancher/k3s/server/audit.yaml
```
```
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  - level: Metadata
```
3. Create config.yaml file and paste the following code in it:
```
sudo nano /etc/rancher/k3s/config.yaml
```
```
kube-apiserver-arg:
  - audit-log-path=/var/lib/rancher/k3s/server/logs/audit.log
  - audit-policy-file=/var/lib/rancher/k3s/server/audit.yaml
  - audit-log-maxage=30
  - audit-log-maxbackup=10
  - audit-log-maxsize=100
```
4. Restart K3S
```
sudo systemctl restart k3s
```
7. Verify audit logs are working
```
kubectl get pods -A
sudo tail -f /var/lib/rancher/k3s/server/logs/audit.log
```

## Enable Operational Monitoring
First create a Log Analytics Workspace that will be used for Kubernetes operational monitoring. Then go to Azure -> Monitor -> Insights -> Containers. Enable monitoring under "Unmonitored clusters". Under Monitor Settings select "Customize capabilities" and select the Log Analytics Workspace that you created. Ensure that the cluster appears under the Monitored clusters.


## Onboard K3S server to Azure Arc servers
Make sure to register the following resource providers on the subscription where the Azure Arc server resource will be created.
- Microsoft.HybridCompute
- Microsoft.GuestConfiguration
- Microsoft.HybridConnectivity


Download Arc Server onboarding script to Linux server
```
wget https://raw.githubusercontent.com/sukster/azure-arc-k3s/refs/heads/main/az_connect_linux.sh
```
Make sure to update the environment variables in the script.


<br>Run the script as a regular user (not with sudo).
```
./az_connect_linux.sh
```

## Optional: Deploy Kubernetes Goat
For security testing install Kubernetes Goat: https://github.com/madhuakula/kubernetes-goat
