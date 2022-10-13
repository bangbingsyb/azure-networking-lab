#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

PREFIX=$1
SUB=$2
REGION=$3

RG="${PREFIX}-nginx-$REGION"
RG_APP="${PREFIX}-app-$REGION"
RG_GLOBAL="${PREFIX}-global-$REGION"

KEYVAULT_NAME="${PREFIX}nginx"
STORAGE_NAME="${PREFIX}nginx"
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
