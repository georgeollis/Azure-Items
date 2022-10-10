targetScope = 'managementGroup'

output policyName string =  diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticsSettingsAVDHostPool'
  properties: {
    displayName: 'Enable Diagnostic Settings for Azure Virtual Desktop HostPool - Log Analytics'
    description: 'Apply diagnostic settings for Azure Azure Virtual Desktop HostPool to send data to central Log Analytics workspace'
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
      Connection:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AgentHealthStatus:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      HostRegistration:{
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
        equals: 'Microsoft.DesktopVirtualization/hostpools'
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
                  '[parameters(\'Connection\')]'
                  '[parameters(\'AgentHealthStatus\')]'
                  '[parameters(\'HostRegistration\')]'
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
                  Connection:{
                    type: 'string'
                  }
                  AgentHealthStatus:{
                    type: 'string'
                  }
                  HostRegistration:{
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.DesktopVirtualization/hostpools/providers/diagnosticSettings'
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
                          category: 'Connection'
                          enabled: '[parameters(\'Connection\')]'
                        }
                        {
                          category: 'HostRegistration'
                          enabled: '[parameters(\'HostRegistration\')]'
                        }
                        {
                          category: 'AgentHealthStatus'
                          enabled: '[parameters(\'AgentHealthStatus\')]'
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
                Connection:{
                  value: '[parameters(\'Connection\')]'
                }
                HostRegistration:{
                  value: '[parameters(\'HostRegistration\')]'
                }
                AgentHealthStatus:{
                  value: '[parameters(\'AgentHealthStatus\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
