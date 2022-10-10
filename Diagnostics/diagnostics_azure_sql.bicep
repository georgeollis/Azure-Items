targetScope = 'managementGroup'

output policyName string = diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticSettingsAzureSql'
  properties: {
    displayName: 'Enable Diagnostic Settings for Azure SQL - Log Analytics'
    description: 'Apply diagnostic settings for Azure SQL to send data to central Log Analytics workspace'
    parameters: {
      logAnalytics: {
        type: 'String'
      }
      sqlInsights: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      automaticTuning: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      queryStoreRuntimeStatistics: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      queryStoreWaitStatistics: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      errors: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      databaseWaitStatistics: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      timeouts: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      blocks: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      deadlocks: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      Basic: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      InstanceAndAppAdvanced: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      WorkloadManagement: {
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
        equals: 'Microsoft.Sql/servers/databases'
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
                in: [
                  '[parameters(\'Basic\')]'
                  '[parameters(\'InstanceAndAppAdvanced\')]'
                  '[parameters(\'WorkloadManagement\')]'
                ]
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                in: [
                  '[parameters(\'sqlInsights\')]'
                  '[parameters(\'automaticTuning\')]'
                  '[parameters(\'queryStoreRuntimeStatistics\')]'
                  '[parameters(\'queryStoreWaitStatistics\')]'
                  '[parameters(\'databaseWaitStatistics\')]'
                  '[parameters(\'timeouts\')]'
                  '[parameters(\'blocks\')]'
                  '[parameters(\'deadlocks\')]'
                  '[parameters(\'errors\')]'
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
                  sqlInsights:{
                    type: 'string'
                  }
                  automaticTuning:{
                    type: 'string'
                  }
                  queryStoreRuntimeStatistics:{
                    type: 'string'
                  }
                  queryStoreWaitStatistics:{
                    type: 'string'
                  }
                  databaseWaitStatistics:{
                    type: 'string'
                  }
                  timeouts:{
                    type: 'string'
                  }
                  blocks:{
                    type: 'string'
                  }
                  deadlocks:{
                    type: 'string'
                  }
                  errors: {
                    type: 'string'
                  }
                  Basic:{
                    type: 'string'
                  }
                  InstanceAndAppAdvanced:{
                    type: 'string'
                  }
                  WorkloadManagement:{
                    type: 'string'
                  }
                }
                variables: {}                
                resources: [
                  {
                    type: 'Microsoft.Sql/servers/databases/providers/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    name: '[concat(parameters(\'resourceName\'), \'/\', \'Microsoft.Insights/setByPolicy\')]'
                    location: '[parameters(\'location\')]'
                    dependsOn: []
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      metrics: [
                        {
                          category: 'Basic'
                          enabled: '[parameters(\'Basic\')]'
                        }
                        {
                          category: 'InstanceAndAppAdvanced'
                          enabled: '[parameters(\'InstanceAndAppAdvanced\')]'
                        }
                        {
                          category: 'WorkloadManagement'
                          enabled: '[parameters(\'WorkloadManagement\')]'
                        }
                      ]
                      logs: [
                        {
                          category: 'SQLInsights'
                          enabled: '[parameters(\'sqlInsights\')]'
                        }
                        {
                          category: 'AutomaticTuning'
                          enabled: '[parameters(\'automaticTuning\')]'
                        }
                        {
                          category: 'QueryStoreRuntimeStatistics'
                          enabled: '[parameters(\'queryStoreRuntimeStatistics\')]'
                        }
                        {
                          category: 'QueryStoreWaitStatistics'
                          enabled: '[parameters(\'queryStoreWaitStatistics\')]'
                        }
                        {
                          category: 'DatabaseWaitStatistics'
                          enabled: '[parameters(\'databaseWaitStatistics\')]'
                        }
                        {
                          category: 'Timeouts'
                          enabled: '[parameters(\'timeouts\')]'
                        }
                        {
                          category: 'Blocks'
                          enabled: '[parameters(\'blocks\')]'
                        }
                        {
                          category: 'Deadlocks'
                          enabled: '[parameters(\'deadlocks\')]'
                        }
                        {
                          category: 'Errors'
                          enabled: '[parameters(\'errors\')]'
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
                  value: '[field(\'fullName\')]'
                }
                sqlInsights: {
                  value: '[parameters(\'sqlInsights\')]'
                }
                automaticTuning:{
                  value: '[parameters(\'automaticTuning\')]'
                }
                queryStoreRuntimeStatistics:{
                  value: '[parameters(\'queryStoreRuntimeStatistics\')]'
                }
                queryStoreWaitStatistics:{
                  value: '[parameters(\'queryStoreWaitStatistics\')]'
                }
                databaseWaitStatistics:{
                  value: '[parameters(\'databaseWaitStatistics\')]'
                }
                errors:{
                  value: '[parameters(\'errors\')]'
                }
                timeouts:{
                  value: '[parameters(\'timeouts\')]'
                }
                deadlocks:{
                  value: '[parameters(\'deadlocks\')]'
                }
                blocks:{
                  value: '[parameters(\'blocks\')]'
                }
                Basic:{
                  value: '[parameters(\'Basic\')]'
                }
                WorkloadManagement:{
                  value: '[parameters(\'WorkloadManagement\')]'
                }
                InstanceAndAppAdvanced:{
                  value: '[parameters(\'InstanceAndAppAdvanced\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
