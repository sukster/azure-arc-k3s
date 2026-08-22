# Deploy and connect K3S to Azure Arc


## Install K3S on Linux server
Use the official quick start guide: https://docs.k3s.io/quick-start. I tested this on Ubuntu server 22.04 LTS.


## Create service principal in Azure Arc
Go to Azure Arc –> Additional Setup -> Service Principals. For "Scope assignment level" select only the Resource Group. For "Roles" select Kubernetes Cluster - Azure Arc Onboarding. Save the App ID and Secret to a save location. We will need it for the script later.


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


## Enable Defender for Containers
Go to Azure -> Defender for Cloud -> Environment Settings -> Your Subscription and turn on Defender for Containers plan.


## Configure K3s audit logging
1. Create a directory for the audit logs: 
..sudo mkdir -p -m 700 /var/lib/rancher/k3s/server/logs


## Enable Control Plane Monitoring
This step will enable collection of audit events from K3S which are useful for security investigations.
1. Download the ARM template to Azure admin's computer: https://raw.githubusercontent.com/sukster/azure-arc-k3s/refs/heads/main/audit_diagnostic_settings.json
2. Go to Azure and search for "Deploy a custom template"
3. Select "Build your own template in the editor"
4. Erase the sample code and paste the contents of the audit_diagnostic_settings.json and then click Save
5. Select the subscription and resource group where the Azure Arc Kubernetes cluster is placed.
6. For Workspace Id insert the resource Id for the Sentinel's Log Analytics Workspace. You can find it by going to the Log Analytics Workspace overview page and click the "JSON view".
<img width="862" height="361" alt="image" src="https://github.com/user-attachments/assets/5f1dca87-642b-4795-beb7-ab3ab61b3766" />


## Optional: Enable Operational Monitoring
First create a Log Analytics Workspace that will be used for Kubernetes operational monitoring. Then go to Azure -> Monitor -> Insights -> Containers. Enable monitoring under "Unmonitored clusters". Under Monitor Settings select "Customize capabilities" and select the Log Analytics Workspace that you created. Ensure that the cluster appears under the Monitored clusters.


## Optional: Deploy Kubernetes Goat
For security testing install Kubernetes Goat: https://github.com/madhuakula/kubernetes-goat
