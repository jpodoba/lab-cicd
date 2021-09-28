# Infra deployment

Deploy template with:

```
az login

az account set --subscription <subscriptionId>

az group create --name <resourceGroupName> --location northeurope

az deployment group create --resource-group <resourceGroupName> --template-file main.bicep --parameter dev.parameters.json
```