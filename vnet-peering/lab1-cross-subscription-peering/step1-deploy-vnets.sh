az login

ADMINPASSWORD=$1
if [ -z "${ADMINPASSWORD}" ];
then
    echo "VM admin password must be provided."
    exit 32
fi

export SUB1="bc3b91ed-1253-42b5-826d-de20de48b2d9"
export REGION1="westus2"
export RG1="demo-vnet1-$REGION1"

export SUB2="e3853e83-0d02-4fb3-b88f-05b5fd21aee2"
export REGION2="southcentralus"
export RG2="demo-vnet2-$REGION2"

az account set --subscription $SUB1
az group create --name $RG1 --location $REGION1
az deployment group create --resource-group $RG1 --template-file step1-vnet.json --parameters step1-vnet1.parameters.json --parameters adminPassword=$ADMINPASSWORD --verbose

az account set --subscription $SUB2
az group create --name $RG2 --location $REGION2
az deployment group create --resource-group $RG2 --template-file step1-vnet.json --parameters step1-vnet2.parameters.json --parameters adminPassword=$ADMINPASSWORD --verbose
