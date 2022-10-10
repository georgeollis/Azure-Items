targetScope = 'managementGroup'

output policyName string =  diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'diagnosticsSettingsAutomationAccounts'
  properties: {
    displayName: 'Enable Diagnostic Settings for Automation Accounts - Log Analytics'
    description: 'Apply diagnostic settings for Azure Automation Accounts to send data to central Log Analytics workspace'
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
      jobLogs:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      jobStreams:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      dscNodeStatus:{
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      auditEvent:{
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
        equals: 'Microsoft.Automation/automationAccounts'
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
                  '[parameters(\'jobLogs\')]'
                  '[parameters(\'jobStreams\')]'
                  '[parameters(\'dscNodeStatus\')]'
                  '[parameters(\'auditEvent\')]'
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
                  jobLogs: {
                    type: 'string'
                  }
                  jobStreams: {
                    type: 'string'
                  }
                  dscNodeStatus: {
                    type: 'string'
                  }
                  auditEvent:{
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.Automation/automationAccounts/providers/diagnosticSettings'
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
                          category: 'JobLogs'
                          enabled: '[parameters(\'jobLogs\')]'
                        }
                        {
                          category: 'JobStreams'
                          enabled: '[parameters(\'jobStreams\')]'
                        }
                        {
                          category: 'DscNodeStatus'
                          enabled: '[parameters(\'dscNodeStatus\')]'
                        }
                        {
                          category: 'AuditEvent'
                          enabled: '[parameters(\'auditEvent\')]'
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
                jobLogs:{
                  value: '[parameters(\'jobLogs\')]'
                }
                jobStreams:{
                  value: '[parameters(\'jobStreams\')]'
                }
                dscNodeStatus: {
                  value: '[parameters(\'dscNodeStatus\')]'
                }
                auditEvent: {
                  value: '[parameters(\'auditEvent\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
