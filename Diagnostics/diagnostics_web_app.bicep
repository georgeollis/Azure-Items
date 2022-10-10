targetScope = 'managementGroup'

output policyName string = diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticSettingsWebApp'
  properties: {
    displayName: 'Enable Diagnostic Settings for Azure Web App - Log Analytics'
    description: 'Apply diagnostic settings for Azure Web App to send data to central Log Analytics workspace'
    parameters: {
      logAnalytics: {
        type: 'String'
      }
      metricsEnabled: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      appServiceHTTPLogs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      appServiceConsoleLogs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      appServiceAppLogs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      appServiceAuditLogs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      appServiceIPSecAuditLogs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      appServicePlatformLogs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Web/sites'
          }
          {
            field: 'kind'
            matchInsensitively: 'app'
          }
        ]
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          type: 'Microsoft.Insights/diagnosticSettings'
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Insights/diagnosticSettings/metrics.enabled'
                equals: '[parameters(\'metricsEnabled\')]'
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                in: [
                  '[parameters(\'appServiceHTTPLogs\')]'
                  '[parameters(\'appServiceConsoleLogs\')]'
                  '[parameters(\'appServiceAppLogs\')]'
                  '[parameters(\'appServiceAuditLogs\')]'
                  '[parameters(\'appServiceIPSecAuditLogs\')]'
                  '[parameters(\'appServicePlatformLogs\')]'
                ]
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/workspaceId'
                matchInsensitively: '[parameters(\'logAnalytics\')]'
              }
            ]
          }
          deployment: {
            properties: {
              mode: 'incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  resourceName: {
                    type: 'string'
                  }
                  logAnalytics: {
                    type: 'string'
                  }
                  location: {
                    type: 'string'
                  }
                  metricsEnabled:{
                    type: 'string'
                  }
                  appServiceHTTPLogs:{
                    type: 'string'
                  }
                  appServiceConsoleLogs:{
                    type: 'stirng'
                  }
                  appServiceAppLogs: {
                    type: 'string'
                  }
                  appServiceAuditLogs:{
                    type: 'string'
                  }
                  appServiceIPSecAuditLogs:{
                    type: 'string'
                  }
                  appServicePlatformLogs:{
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Web/sites/providers/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    name: '[concat(parameters(\'resourceName\'), \'/\', \'Microsoft.Insights/setByPolicy\')]'
                    location: '[parameters(\'location\')]'
                    dependsOn: []
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      metrics: [
                        {
                          category: 'AllMetrics'
                          enabled: '[parameters(\'metricsEnabled\')]'
                          retentionPolicy: {
                            days: 0
                            enabled: false
                          }
                          timeGrain: null
                        }
                      ]
                      logs: [
                        {
                          category: 'AppServiceHTTPLogs'
                          enabled: '[parameters(\'appServiceHTTPLogs\')]'
                        }
                        {
                          category: 'AppServiceConsoleLogs'
                          enabled: '[parameters(\'appServiceConsoleLogs\')]'
                        }
                        {
                          category: 'AppServiceAppLogs'
                          enabled: '[parameters(\'appServiceAppLogs\')]'
                        }
                        {
                          category: 'AppServiceAuditLogs'
                          enabled: '[parameters(\'appServiceAuditLogs\')]'
                        }
                        {
                          category: 'AppServiceIPSecAuditLogs'
                          enabled: '[parameters(\'appServiceIPSecAuditLogs\')]'
                        }
                        {
                          category: 'AppServicePlatformLogs'
                          enabled: '[parameters(\'appServicePlatformLogs\')]'
                        }
                      ]
                    }
                  }
                ]
                outputs: {}
              }
              parameters: {
                logAnalytics: {
                  value: '[parameters(\'logAnalytics\')]'
                }
                location: {
                  value: '[field(\'location\')]'
                }
                resourceName: {
                  value: '[field(\'name\')]'
                }
                appServiceHTTPLogs:{
                  value: '[parameters(\'appServiceHTTPLogs\')]'
                }
                appServiceConsoleLogs:{
                  value: '[parameters(\'appServiceConsoleLogs\')]'
                }
                appServiceAppLogs:{
                  value: '[parameters(\'appServiceAppLogs\')]'
                }
                appServiceAuditLogs:{
                  value: '[parameters(\'appServiceAuditLogs\')]'
                }
                appServiceIPSecAuditLogs:{
                  value: '[parameters(\'appServiceIPSecAuditLogs\')]'
                }
                appServicePlatformLogs:{
                  value: '[parameters(\'appServicePlatformLogs\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
