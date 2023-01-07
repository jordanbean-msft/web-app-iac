param appName string
param region string
param environment string

output appServicePlanName string = 'asp-${appName}-${region}-${environment}'
output appServiceName string = 'wa-${appName}-${region}-${environment}'
output sqlServerName string = 'sql-${appName}-${region}-${environment}'
output sqlDatabaseName string = 'db-${appName}-${region}-${environment}'
output managedIdentityName string = 'mi-${appName}-${region}-${environment}'
output keyVaultName string = 'kv-${appName}-${region}-${environment}'
output appInsightsName string = 'ai-${appName}-${region}-${environment}'
output logAnalyticsWorkspaceName string = 'la-${appName}-${region}-${environment}'
output sqlDatabaseConnectionStringSecretName string = 'sqlConnectionString'
