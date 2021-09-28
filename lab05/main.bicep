@description('The name of the application')
@minLength(3)
@maxLength(7)
param prefix string

@description('Location for deploy resources')
param location string = resourceGroup().location

@description('The tags that will be associated to resources')
param tags object

var random = '${prefix}${uniqueString(subscription().id)}'
var appName = '${substring(random, 0, 10)}'

var sqlName = toLower('${appName}sql')
var sqlDbName = 'partsunlimited'

var webServerName = toLower('${appName}aps')

var webSiteName = toLower('${appName}web')
var webQa = toLower('${webSiteName}-qa')
var webProd = toLower('${webSiteName}-prod')

var sqlAdministratorLogin = 'user${uniqueString(resourceGroup().id)}'
var sqlAdministratorLoginPassword = 'p@!!${uniqueString(resourceGroup().id)}'

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
  }
  tags: tags
}

resource db 'Microsoft.Sql/servers/databases@2019-06-01-preview' = {
  name: '${sqlServer.name}/${sqlDbName}'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
  sku: {
    name: 'Basic'
  }
  tags: tags
}

resource webServer 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: webServerName
  location: location
  sku: {
    name: 'S1'
  }
  tags: tags
}

resource appServiceQa 'Microsoft.Web/sites@2021-01-15' = {
  name: webQa
  location: location
  properties: {
    serverFarmId: webServer.id
    siteConfig: {
      netFrameworkVersion: 'v4.0'
    }
  }
  tags: tags
  dependsOn: [
    webServer
  ]
}

resource appServiceProd 'Microsoft.Web/sites@2021-01-15' = {
  name: webProd
  location: location
  properties: {
    serverFarmId: webServer.id
    siteConfig: {
      netFrameworkVersion: 'v4.0'
    }
  }
  tags: tags
  dependsOn: [
    webServer
  ]
}

output sqlAdministratorLogin string = sqlAdministratorLogin
output sqlAdministratorLoginPassword string = sqlAdministratorLoginPassword
