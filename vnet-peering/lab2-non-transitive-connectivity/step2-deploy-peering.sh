az login

export SUB="bc3b91ed-1253-42b5-826d-de20de48b2d9"
export REGION="westus2"
export RG="nontransitive-connectivity"

az account set --subscription $SUB
az deployment group create --resource-group $RG --template-file step2-peering.json --parameters step2-peering-vnet1.parameters.json --parameters targetVNetSubscriptionId=$SUB targetVNetResourceGroupName=$RG --verbose
az deployment group create --resource-group $RG --template-file step2-peering.json --parameters step2-peering-vnet2.parameters.json --parameters targetVNetSubscriptionId=$SUB targetVNetResourceGroupName=$RG --verbose
