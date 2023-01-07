param appName string
param region string
param environment string
@secure()
param administratorLogin string
@secure()
param administratorLoginPassword string
param location string = resourceGroup().location

module names 'resource-names.bicep' = {
  name: 'resource-names'
  params: {
    appName: appName
    region: region
    environment: environment
  }
}

module loggingDeployment 'logging.bicep' = {
  name: 'logging-deployment'
  params: {
    appInsightsName: names.outputs.appInsightsName
    logAnalyticsWorkspaceName: names.outputs.logAnalyticsWorkspaceName
    location: location
  }
}

module managedIdentityDeployment 'managed-identity.bicep' = {
  name: 'managed-identity-deployment'
  params: {
    location: location
    managedIdentityName: names.outputs.managedIdentityName
  }
}

module keyVaultDeployment 'key-vault.bicep' = {
  name: 'key-vault-deployment'
  params: {
    keyVaultName: names.outputs.keyVaultName
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    location: location
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

module sqlDeployment 'sql.bicep' = {
  name: 'sql-deployment'
  params: {
    sqlServerName: names.outputs.sqlServerName
    sqlDatabaseName: names.outputs.sqlDatabaseName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    sqlDatabaseConnectionStringSecretName: names.outputs.sqlDatabaseConnectionStringSecretName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

module appServiceDeployment 'app-service.bicep' = {
  name: 'app-service-deployment'
  params: {
    appInsightsName: loggingDeployment.outputs.appInsightsName
    appServiceName: names.outputs.appServiceName
    appServicePlanName: names.outputs.appServicePlanName
    keyVaultName: keyVaultDeployment.outputs.keyVaultName
    location: location
    logAnalyticsWorkspaceName: loggingDeployment.outputs.logAnalyticsWorkspaceName
    managedIdentityName: managedIdentityDeployment.outputs.managedIdentityName
    sqlDbConnectionStringSecretName: sqlDeployment.outputs.sqlDatabaseConnectionStringSecretName
  }
}
