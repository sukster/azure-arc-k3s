#!/bin/sh

sudo apt update

# Run this script as a regular user (not with sudo)
# <--- Change the following environment variables according to your Azure service principal name --->

echo "Exporting environment variables"
export appId='<Your Azure service principal name>'
export password='<Your Azure service principal password>'
export tenantId='<Your Azure tenant ID>'
export resourceGroup='<Azure resource group name>'
export arcClusterName='<The name of your k8s cluster as it will be shown in Azure Arc>'

# Installing Helm
echo "Installing Helm"
sudo snap install helm --classic

# Installing Azure CLI & Azure Arc Extensions
echo "Installing Azure CLI & Azure Arc Extensions"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az extension add --name connectedk8s
az extension add --name k8s-configuration
az extension add --name k8s-extension
az extension add --name customlocation

echo "Log in to Azure using service principal"
az login --service-principal --username $appId --password=$password --tenant $tenantId

echo "Coping config files and setting permissions"
sudo cat <<EOT >> az.sh
#!/bin/sh
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown -R "$USER:$USER" ~/.kube
chmod 700 ~/.kube
chmod 600 ~/.kube/config
echo 'export KUBECONFIG=$HOME/.kube/config' >> ~/.bashrc
mkdir -p ~/.azure
sudo chown -R "$USER:$USER" ~/.azure
chmod 700 ~/.azure
chmod 600 ~/.azure/config
EOT
sudo chmod +x az.sh
. ./az.sh
sudo rm az.sh

echo "Connecting the cluster to Azure Arc"
az connectedk8s connect --name $arcClusterName --resource-group $resourceGroup
# az k8s-extension create --name "aksarc-azuremonitor" --cluster-name $arcClusterName --resource-group $resourceGroup --cluster-type connectedClusters --extension-type Microsoft.AKSArc.AzureMonitor
# az k8s-extension create --name "azuremonitor-containers" --cluster-name $arcClusterName --resource-group $resourceGroup --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers
