targetScope = 'managementGroup'

output policyName string =  diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticsSettingsNsg'
  properties: {
    displayName: 'Enable Diagnostic Settings for Network Security Groups - Log Analytics'
    description: 'Apply diagnostic settings for Azure Network Security Groups to send data to central Log Analytics workspace'
    parameters: {
      logAnalytics: {
        type: 'String'
      }
      NetworkSecurityGroupRuleCounter:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      NetworkSecurityGroupEvent:{
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
        equals: 'Microsoft.Network/networkSecurityGroups'
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
                field: 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                in: [
                  '[parameters(\'NetworkSecurityGroupRuleCounter\')]'
                  '[parameters(\'NetworkSecurityGroupEvent\')]'
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
                  NetworkSecurityGroupRuleCounter: {
                    type: 'string'
                  }
                  NetworkSecurityGroupEvent: {
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Network/networkSecurityGroups/providers/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    name: '[concat(parameters(\'resourceName\'), \'/\', \'Microsoft.Insights/setByPolicy\')]'
                    location: '[parameters(\'location\')]'
                    dependsOn: []
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      logs: [
                        {
                          category: 'NetworkSecurityGroupRuleCounter'
                          enabled: '[parameters(\'NetworkSecurityGroupRuleCounter\')]'
                        }
                        {
                          category: 'NetworkSecurityGroupEvent'
                          enabled: '[parameters(\'NetworkSecurityGroupEvent\')]'
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
                NetworkSecurityGroupRuleCounter:{
                  value: '[parameters(\'NetworkSecurityGroupRuleCounter\')]'
                }
                NetworkSecurityGroupEvent:{
                  value: '[parameters(\'NetworkSecurityGroupEvent\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
