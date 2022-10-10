targetScope = 'managementGroup'

output policyName string =  diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticsSettingsAVDWorkspace'
  properties: {
    displayName: 'Enable Diagnostic Settings for Azure Virtual Desktop Workspace - Log Analytics'
    description: 'Apply diagnostic settings for Azure Azure Virtual Desktop Workspace to send data to central Log Analytics workspace'
    parameters: {
      logAnalytics: {
        type: 'String'
      }
      Checkpoint:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      Error:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      Management:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      Feed:{
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
        equals: 'Microsoft.DesktopVirtualization/workspaces'
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
                  '[parameters(\'Management\')]'
                  '[parameters(\'Error\')]'
                  '[parameters(\'Management\')]'
                  '[parameters(\'Feed\')]'
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
                  Checkpoint: {
                    type: 'string'
                  }
                  Error: {
                    type: 'string'
                  }
                  Management: {
                    type: 'string'
                  }
                  Feed:{
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.DesktopVirtualization/workspaces/providers/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    name: '[concat(parameters(\'resourceName\'), \'/\', \'Microsoft.Insights/setByPolicy\')]'
                    location: '[parameters(\'location\')]'
                    dependsOn: []
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      logs: [
                        {
                          category: 'Checkpoint'
                          enabled: '[parameters(\'Checkpoint\')]'
                        }
                        {
                          category: 'Error'
                          enabled: '[parameters(\'Error\')]'
                        }
                        {
                          category: 'Management'
                          enabled: '[parameters(\'Management\')]'
                        }
                        {
                          category: 'Feed'
                          enabled: '[parameters(\'Feed\')]'
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
                Checkpoint:{
                  value: '[parameters(\'Checkpoint\')]'
                }
                Error:{
                  value: '[parameters(\'Error\')]'
                }
                Management: {
                  value: '[parameters(\'Management\')]'
                }
                Feed:{
                  value: '[parameters(\'Feed\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
