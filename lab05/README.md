# Introduction

- [Bicep documentation](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/)

- [How to install Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)

# Infra deployment

Deploy template with:

```
az login

az account set --subscription <subscriptionId>

az group create --name <resourceGroupName> --location northeurope

az deployment group create --resource-group <resourceGroupName> --template-file main.bicep --parameter dev.parameters.json
```