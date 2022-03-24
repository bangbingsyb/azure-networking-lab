az login

ADMINPASSWORD=$1
if [ -z "${ADMINPASSWORD}" ];
then
    echo "VM admin password must be provided."
    exit 32
fi

export SUB="bc3b91ed-1253-42b5-826d-de20de48b2d9"
export REGION="westus2"
export RG="demo-non-transitive"

az account set --subscription $SUB
az group create --name $RG --location $REGION
az deployment group create --resource-group $RG --template-file step1-vnet.json --parameters step1-vnet1.parameters.json --parameters adminPassword=$ADMINPASSWORD --verbose
az deployment group create --resource-group $RG --template-file step1-vnet.json --parameters step1-vnet2.parameters.json --parameters adminPassword=$ADMINPASSWORD --verbose
az deployment group create --resource-group $RG --template-file step1-vnet.json --parameters step1-vnet3.parameters.json --parameters adminPassword=$ADMINPASSWORD --verbose

