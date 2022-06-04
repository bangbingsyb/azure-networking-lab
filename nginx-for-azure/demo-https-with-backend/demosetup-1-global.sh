#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

PREFIX=$1
SUB=$2
REGION=$3

RG="${PREFIX}-global-${REGION}"
STORAGE_NAME="${PREFIX}nginx"
KEYVAULT_NAME="${PREFIX}nginx"

STORAGE_CONTAINER_NAME="demo-app"
KEYVAULT_CERT_NAME="tlscert"
MI_NAME="demo-mi"

# Disable auto-translation of Resource IDs - only needed for running Azure CLI with Git Bash
# https://github.com/Azure/azure-cli/blob/dev/doc/use_cli_with_git_bash.md#auto-translation-of-resource-ids
export MSYS_NO_PATHCONV=1

dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

az login
az account set --subscription $SUB
az group create --name $RG --location $REGION

# Create a storage account and a public blob container. Upload global assets to the blob container.
az storage account create --name $STORAGE_NAME --resource-group $RG --location $REGION --sku Standard_LRS --kind StorageV2

scope="/subscriptions/$SUB/resourceGroups/$RG/providers/Microsoft.Storage/storageAccounts/$STORAGE_NAME"
objectId=$(az ad signed-in-user show --query objectId -o tsv)

az role assignment create \
    --role "Storage Blob Data Contributor" \
    --assignee "$objectId" \
    --scope "$scope"

az storage container create --account-name $STORAGE_NAME --name $STORAGE_CONTAINER_NAME --public-access blob --auth-mode login

az storage blob upload \
    --account-name $STORAGE_NAME \
    --container-name $STORAGE_CONTAINER_NAME \
    --name contents.zip \
    --file "demo-app/contents.zip" \
    --auth-mode login

az storage blob upload \
    --account-name $STORAGE_NAME \
    --container-name $STORAGE_CONTAINER_NAME \
    --name eat-a-rainbow.jpg \
    --file "demo-app/eat-a-rainbow.jpg" \
    --auth-mode login

az storage blob upload \
    --account-name $STORAGE_NAME \
    --container-name $STORAGE_CONTAINER_NAME \
    --name setup.sh \
    --file "demo-app/setup.sh" \
    --auth-mode login

# Create a key vault and upload the TLS certificate
az keyvault create --name $KEYVAULT_NAME --resource-group $RG --location $REGION --sku standard

az keyvault set-policy --name $KEYVAULT_NAME --object-id $objectId --certificate-permissions create delete get list import update

az keyvault certificate import --vault-name $KEYVAULT_NAME --name $KEYVAULT_CERT_NAME --file ./conf/ContosoPem.pem

# Create a user assigned managed identity and add it to the key vault access policy
az identity create --name $MI_NAME --resource-group $RG

miPrincipalId=$(az identity show --name $MI_NAME --resource-group $RG --query principalId -o tsv)
az keyvault set-policy --name $KEYVAULT_NAME --object-id $miPrincipalId --secret-permissions get
