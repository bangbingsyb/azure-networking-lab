#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

SUB="bc3b91ed-1253-42b5-826d-de20de48b2d9"
REGION="eastus2"
RG="demo-nginx-$REGION"
RG_APP="demo-app-$REGION"
RG_GLOBAL="demo-global"

KEYVAULT_NAME="demonginx"
STORAGE_NAME="demonginx"
KEYVAULT_CERT_NAME="tlscert"
MI_NAME="demo-mi"

az login
az account set --subscription $SUB
az group create --name $RG --location $REGION

az deployment group create --resource-group $RG --template-file nginx-tls.json --parameters \
    virtualNetworkResourceGroupName=$RG_APP \
    userAssignedIdentityResourceGroupName=$RG_GLOBAL \
    keyVaultName=$KEYVAULT_NAME \
    keyVaultCertificateName=$KEYVAULT_CERT_NAME
