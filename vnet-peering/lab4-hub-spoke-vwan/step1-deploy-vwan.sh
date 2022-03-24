az login

export SUB="bc3b91ed-1253-42b5-826d-de20de48b2d9"
export REGION="westus2"
export RG="demo-vwan"

az account set --subscription $SUB
az group create --name $RG --location $REGION
az deployment group create --resource-group $RG --template-file step1-vwan.json --parameters step1-vwan.parameters.json --verbose
