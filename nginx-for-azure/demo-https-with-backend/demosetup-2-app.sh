#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

PREFIX=$1
SUB=$2
REGION=$3

RG="${PREFIX}-app-${REGION}"
STORAGE_NAME="${PREFIX}nginx"

az login
az account set --subscription $SUB
az group create --name $RG --location $REGION

az deployment group create --resource-group $RG --template-file network.json

ssh-keygen -t rsa -b 2048 -f sshkey -N ""
adminPublicKey="$(cat sshkey.pub)"
echo "$adminPublicKey"

az deployment group create --resource-group $RG --template-file app-compute.json --parameters storageAccountName=$STORAGE_NAME adminPublicKey=$adminPublicKey
