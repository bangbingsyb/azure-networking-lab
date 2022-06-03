## West US 2

### Network and application setup

```
az group create --name demo-app-wus2 --location westus2
az deployment group create --resource-group demo-app-wus2 --template-file network.json
az deployment group create --resource-group demo-app-wus2 --template-file app-compute.json
```

### NGINX setup
```
az group create --name demo-nginx-wus2 --location westus2
```

HTTP scenario
```
az deployment group create --resource-group demo-nginx-wus2 --template-file nginx.json --parameters virtualNetworkResourceGroupName=demo-app-wus2
```

HTTPS scenario
```
az deployment group create --resource-group demo-nginx-wus2 --template-file nginx-tls.json --parameters virtualNetworkResourceGroupName=demo-app-wus2 keyVaultResourceGroupName=demo-common keyVaultName=nginxdemo keyVaultCertificateName=tlscert
```
