az login

set customerSubscriptionId="<customer-subscription-id>"
set customerResourceGroup="customer-rg"
set providerSubscriptionId="<provider-subscription-id>"
set providerResourceGroup="provider-rg"
set sshKey="<ssh-key-for-vmss>"

az account set --subscription %customerSubscriptionId%
az group create --name %customerResourceGroup% --location westcentralus
az deployment group create --resource-group %customerResourceGroup% --template-file customer_step1.json --verbose

az account set --subscription %providerSubscriptionId%
az group create --name %providerResourceGroup% --location westcentralus
az deployment group create --resource-group %providerResourceGroup% --template-file provider_step2.json --verbose
az deployment group create --resource-group %providerResourceGroup% --template-file provider_step3.json --parameters customerSubscriptionId=%customerSubscriptionId% customerResourceGroupName=%customerResourceGroup% adminKey=%sshKey% --verbose
