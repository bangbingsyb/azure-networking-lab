az login

export SUB1="bc3b91ed-1253-42b5-826d-de20de48b2d9"
export REGION1="westus2"
export RG1="demo-vnet1-$REGION1"

export SUB2="e3853e83-0d02-4fb3-b88f-05b5fd21aee2"
export REGION2="southcentralus"
export RG2="demo-vnet2-$REGION2"

az account set --subscription $SUB1
az deployment group create --resource-group $RG1 --template-file step2-peering.json --parameters step2-peering-vnet1.parameters.json --parameters targetVNetSubscriptionId=$SUB2 targetVNetResourceGroupName=$RG2 --verbose

az account set --subscription $SUB2
az deployment group create --resource-group $RG2 --template-file step2-peering.json --parameters step2-peering-vnet2.parameters.json --parameters targetVNetSubscriptionId=$SUB1 targetVNetResourceGroupName=$RG1 --verbose
