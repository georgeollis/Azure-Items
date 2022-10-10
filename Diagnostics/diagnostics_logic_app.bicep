targetScope = 'managementGroup'

output policyName string = diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id
 
resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'logicAppDiagnosticSetting'
  properties: {
    description: 'This policy will enable diagnostic settings for Azure Logic Apps and send them to Log Analytics. Please select which metrics, logs you require.'
    displayName: 'Enable Diagnostic Settings for Azure Logic Apps - Log Analytics'
    parameters: {
      logAnalytics: {
        type: 'String'
      }
      metricsEnabled: {
        type: 'String'
        allowedValues: [
          'false'
          'true'
        ]
        defaultValue: 'true'
      }
      workflowRuntime:{
        type: 'String'
        allowedValues: [
          'true'
          'false'
        ]
        defaultValue: 'true'
      }
    }
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Logic/workflows'
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
                  '[parameters(\'workflowRuntime\')]'
                ]
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
                  metricsEnabled: {
                    type: 'string'
                  }
                  workflowRuntime:{
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Logic/workflows/providers/diagnosticSettings'
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
                            enabled: false
                            days: 0
                          }
                        }
                      ]
                      logs: [
                        {
                          category: 'WorkflowRuntime'
                          enabled: '[parameters(\'workflowRuntime\')]'
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
                metricsEnabled: {
                  value: '[parameters(\'metricsEnabled\')]'
                }
                workflowRuntime: {
                  value: '[parameters(\'workflowRuntime\')]'
                }
                location: {
                  value: '[field(\'location\')]'
                }
                resourceName: {
                  value: '[field(\'name\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
