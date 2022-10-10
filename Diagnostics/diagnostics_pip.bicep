targetScope = 'managementGroup'

output policyName string =  diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticsSettingsPip'
  properties: {
    displayName: 'Enable Diagnostic Settings for Public IP Addresses - Log Analytics'
    description: 'Apply diagnostic settings for Azure Public IP Addresses to send data to central Log Analytics workspace'
    parameters: {
      logAnalytics: {
        type: 'String'
      }
      metricsEnabled:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      DDoSProtectionNotifications:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      DDoSMitigationFlowLogs:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      DDoSMitigationReports:{
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
        field: 'type'
        equals: 'Microsoft.Network/publicIPAddresses'
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
                  '[parameters(\'DDoSMitigationReports\')]'
                  '[parameters(\'DDoSMitigationFlowLogs\')]'
                  '[parameters(\'DDoSMitigationReports\')]'
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
                  DDoSProtectionNotifications: {
                    type: 'string'
                  }
                  DDoSMitigationFlowLogs: {
                    type: 'string'
                  }
                  DDoSMitigationReports: {
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Network/publicIPAddresses/providers/diagnosticSettings'
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
                          category: 'DDoSProtectionNotifications'
                          enabled: '[parameters(\'DDoSProtectionNotifications\')]'
                        }
                        {
                          category: 'DDoSMitigationFlowLogs'
                          enabled: '[parameters(\'DDoSMitigationFlowLogs\')]'
                        }
                        {
                          category: 'DDoSMitigationReports'
                          enabled: '[parameters(\'DDoSMitigationReports\')]'
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
                metricsEnabled:{
                  value: '[parameters(\'metricsEnabled\')]'
                }
                DDoSProtectionNotifications:{
                  value: '[parameters(\'DDoSProtectionNotifications\')]'
                }
                DDoSMitigationFlowLogs:{
                  value: '[parameters(\'DDoSMitigationFlowLogs\')]'
                }
                DDoSMitigationReports: {
                  value: '[parameters(\'DDoSMitigationReports\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
