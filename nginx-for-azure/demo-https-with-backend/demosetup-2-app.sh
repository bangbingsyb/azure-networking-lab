#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SUB="bc3b91ed-1253-42b5-826d-de20de48b2d9"
REGION="eastus2"
RG="demo-app-$REGION"
STORAGE_NAME="demonginx"

az login
az account set --subscription $SUB
az group create --name $RG --location $REGION

az deployment group create --resource-group $RG --template-file network.json
az deployment group create --resource-group $RG --template-file app-compute.json --parameters storageAccountName=$STORAGE_NAME
