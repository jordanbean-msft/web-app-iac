param sqlServerName string
param sqlDatabaseName string
@secure()
param administratorLogin string
@secure()
param administratorLoginPassword string
param location string
param sqlDatabaseConnectionStringSecretName string
param logAnalyticsWorkspaceName string
param keyVaultName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sql 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${sqlServer.name}/${sqlDatabaseName}'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {}
}

resource diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2017-05-01-preview' = {
  name: 'Logging'
  scope: sql
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        category: 'Errors'
        enabled: true
      }
      {
        category: 'Timeouts'
        enabled: true
      }
      {
        category: 'Blocks'
        enabled: true
      }
      {
        category: 'Deadlocks'
        enabled: true
      }
      {
        category: 'SQLInsights'
        enabled: true
      }
      {
        category: 'DatabaseWaitStatistics'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

var sqlDatabaseConnectionString = 'Server=tcp:${reference(sqlServer.id).fullyQualifiedDomainName},1433;Database=${sql.name};User ID=${administratorLogin};Password=${administratorLoginPassword};Trusted_Connection=False;Encrypt=True;'

resource sqlDatabaseConnectionStringSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: '${keyVault.name}/${sqlDatabaseConnectionStringSecretName}'
  properties: {
    value: sqlDatabaseConnectionString
  }
}

output sqlServerName string = sqlServer.name
output sqlDatabaseName string = sql.name
output sqlDatabaseConnectionStringSecretName string = sqlDatabaseConnectionStringSecretName
