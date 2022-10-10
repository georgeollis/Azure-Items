targetScope = 'managementGroup'

output policyName string =  diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticsSettingsFrontDoor'
  properties: {
    displayName: 'Enable Diagnostic Settings for Front Door - Log Analytics'
    description: 'Apply diagnostic settings for Azure Front Door to send data to central Log Analytics workspace'
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
      FrontdoorAccessLog:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      FrontdoorWebApplicationFirewallLog:{
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
        equals: 'Microsoft.Network/frontdoors'
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
                  '[parameters(\'FrontdoorAccessLog\')]'
                  '[parameters(\'FrontdoorWebApplicationFirewallLog\')]'
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
                  FrontdoorAccessLog: {
                    type: 'string'
                  }
                  FrontdoorWebApplicationFirewallLog: {
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Network/frontdoors/providers/diagnosticSettings'
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
                          category: 'FrontdoorAccessLog'
                          enabled: '[parameters(\'FrontdoorAccessLog\')]'
                        }
                        {
                          category: 'FrontdoorWebApplicationFirewallLog'
                          enabled: '[parameters(\'FrontdoorWebApplicationFirewallLog\')]'
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
                FrontdoorAccessLog:{
                  value: '[parameters(\'FrontdoorAccessLog\')]'
                }
                FrontdoorWebApplicationFirewallLog:{
                  value: '[parameters(\'FrontdoorWebApplicationFirewallLog\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
