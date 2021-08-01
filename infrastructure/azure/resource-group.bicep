param appServicePlanName string
param appServicePlanLocation string = resourceGroup().location
param webAppName string
param webAppLocation string = resourceGroup().location

@allowed([
  'Development'
])
param webApp_ASPNETCORE_ENVIRONMENT string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: appServicePlanName
  location: appServicePlanLocation
  kind: 'linux'
  sku: {
    tier: 'Free'
    name: 'F1'
  }
  properties: {
    targetWorkerSizeId: 0
    targetWorkerCount: 1
  }
}

resource webApp 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName
  location: webAppLocation
  properties: {
    serverFarmId: appServicePlan.id
    clientAffinityEnabled: false
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: webApp_ASPNETCORE_ENVIRONMENT
        }
      ]
      alwaysOn: false
      http20Enabled: true
      linuxFxVersion: 'DOTNETCORE|6.0'
    }
  }
}
