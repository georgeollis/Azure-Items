targetScope = 'managementGroup'

output policyName string = diagnosticSettingsResource.name
output policyId string = diagnosticSettingsResource.id

resource diagnosticSettingsResource 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'rsvDiagnosticSettings'
  properties: {
    displayName: 'Enable Diagnostic Settings for Azure Recovery Services Vault - Log Analytics'
    description: 'Apply diagnostic settings for Azure Recovery Services Vault to send data to central Log Analytics workspace'
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
      AzureBackupReport: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      CoreAzureBackup: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AddonAzureBackupJobs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AddonAzureBackupAlerts: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AddonAzureBackupPolicy: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AddonAzureBackupStorage: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AddonAzureBackupProtectedInstance: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AzureSiteRecoveryJobs: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AzureSiteRecoveryEvents: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AzureSiteRecoveryReplicatedItems: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AzureSiteRecoveryReplicationDataUploadRate: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AzureSiteRecoveryReplicationStats: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AzureSiteRecoveryRecoveryPoints: {
        type: 'String'
        defaultValue: 'true'
        allowedValues: [
          'true'
          'false'
        ]
      }
      AzureSiteRecoveryProtectedDiskDataChurn: {
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
        equals: 'Microsoft.RecoveryServices/vaults'
      }
      then: {
        effect: 'DeployIfNotExists'
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
                  '[parameters(\'AzureBackupReport\')]'
                  '[parameters(\'CoreAzureBackup\')]'
                  '[parameters(\'AddonAzureBackupJobs\')]'
                  '[parameters(\'AddonAzureBackupAlerts\')]'
                  '[parameters(\'AddonAzureBackupPolicy\')]'
                  '[parameters(\'AddonAzureBackupStorage\')]'
                  '[parameters(\'AddonAzureBackupProtectedInstance\')]'
                  '[parameters(\'AzureSiteRecoveryJobs\')]'
                  '[parameters(\'AzureSiteRecoveryEvents\')]'
                  '[parameters(\'AzureSiteRecoveryReplicatedItems\')]'
                  '[parameters(\'AzureSiteRecoveryReplicationStats\')]'
                  '[parameters(\'AzureSiteRecoveryRecoveryPoints\')]'
                  '[parameters(\'AzureSiteRecoveryReplicationDataUploadRate\')]'
                  '[parameters(\'AzureSiteRecoveryProtectedDiskDataChurn\')]'
                ]
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/metrics.enabled'
                equals: '[parameters(\'metricsEnabled\')]'
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
                  metricsEnabled: {
                    type: 'string'
                  }
                  AzureBackupReport: {
                    type: 'string'
                  }
                  CoreAzureBackup: {
                    type: 'string'
                  }
                  AddonAzureBackupJobs: {
                    type: 'string'
                  }
                  AddonAzureBackupAlerts: {
                    type: 'string'
                  }
                  AddonAzureBackupPolicy: {
                    type: 'string'
                  }
                  AddonAzureBackupStorage: {
                    type: 'string'
                  }
                  AddonAzureBackupProtectedInstance: {
                    type: 'string'
                  }
                  AzureSiteRecoveryJobs: {
                    type: 'string'
                  }
                  AzureSiteRecoveryEvents: {
                    type: 'string'
                  }
                  AzureSiteRecoveryReplicatedItems: {
                    type: 'string'
                  }
                  AzureSiteRecoveryReplicationStats: {
                    type: 'string'
                  }
                  AzureSiteRecoveryRecoveryPoints: {
                    type: 'string'
                  }
                  AzureSiteRecoveryReplicationDataUploadRate: {
                    type: 'string'
                  }
                  AzureSiteRecoveryProtectedDiskDataChurn: {
                    type: 'string'
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'Microsoft.RecoveryServices/vaults/providers/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    name: '[concat(parameters(\'resourceName\'), \'/\', \'Microsoft.Insights/setByPolicy\')]'
                    location: '[parameters(\'location\')]'
                    dependsOn: []
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      metrics: [
                        {
                          category: 'Health'
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
                          category: 'AzureBackupReport'
                          enabled: '[parameters(\'AzureBackupReport\')]'
                        }
                        {
                          category: 'CoreAzureBackup'
                          enabled: '[parameters(\'CoreAzureBackup\')]'
                        }
                        {
                          category: 'AddonAzureBackupJobs'
                          enabled: '[parameters(\'AddonAzureBackupJobs\')]'
                        }
                        {
                          category: 'AddonAzureBackupAlerts'
                          enabled: '[parameters(\'AddonAzureBackupAlerts\')]'
                        }
                        {
                          category: 'AddonAzureBackupPolicy'
                          enabled: '[parameters(\'AddonAzureBackupPolicy\')]'
                        }
                        {
                          category: 'AddonAzureBackupStorage'
                          enabled: '[parameters(\'AddonAzureBackupStorage\')]'
                        }
                        {
                          category: 'AddonAzureBackupProtectedInstance'
                          enabled: '[parameters(\'AddonAzureBackupProtectedInstance\')]'
                        }
                        {
                          category: 'AzureSiteRecoveryJobs'
                          enabled: '[parameters(\'AzureSiteRecoveryJobs\')]'
                        }
                        {
                          category: 'AzureSiteRecoveryEvents'
                          enabled: '[parameters(\'AzureSiteRecoveryEvents\')]'
                        }
                        {
                          category: 'AzureSiteRecoveryReplicatedItems'
                          enabled: '[parameters(\'AzureSiteRecoveryReplicatedItems\')]'
                        }
                        {
                          category: 'AzureSiteRecoveryReplicationStats'
                          enabled: '[parameters(\'AzureSiteRecoveryReplicationStats\')]'
                        }
                        {
                          category: 'AzureSiteRecoveryRecoveryPoints'
                          enabled: '[parameters(\'AzureSiteRecoveryRecoveryPoints\')]'
                        }
                        {
                          category: 'AzureSiteRecoveryReplicationDataUploadRate'
                          enabled: '[parameters(\'AzureSiteRecoveryReplicationDataUploadRate\')]'
                        }
                        {
                          category: 'AzureSiteRecoveryProtectedDiskDataChurn'
                          enabled: '[parameters(\'AzureSiteRecoveryProtectedDiskDataChurn\')]'
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
                metricsEnabled: {
                  value: '[parameters(\'metricsEnabled\')]'
                }
                CoreAzureBackup: {
                  value: '[parameters(\'CoreAzureBackup\')]'
                }
                AzureBackupReport: {
                  value: '[parameters(\'AzureBackupReport\')]'
                }
                AddonAzureBackupJobs: {
                  value: '[parameters(\'AddonAzureBackupJobs\')]'
                }
                AddonAzureBackupAlerts: {
                  value: '[parameters(\'AddonAzureBackupAlerts\')]'
                }
                AddonAzureBackupPolicy: {
                  value: '[parameters(\'AddonAzureBackupPolicy\')]'
                }
                AddonAzureBackupStorage: {
                  value: '[parameters(\'AddonAzureBackupStorage\')]'
                }
                AddonAzureBackupProtectedInstance: {
                  value: '[parameters(\'AddonAzureBackupProtectedInstance\')]'
                }
                AzureSiteRecoveryJobs: {
                  value: '[parameters(\'AzureSiteRecoveryJobs\')]'
                }
                AzureSiteRecoveryEvents: {
                  value: '[parameters(\'AzureSiteRecoveryEvents\')]'
                }
                AzureSiteRecoveryReplicatedItems: {
                  value: '[parameters(\'AzureSiteRecoveryReplicatedItems\')]'
                }
                AzureSiteRecoveryReplicationStats: {
                  value: '[parameters(\'AzureSiteRecoveryReplicationStats\')]'
                }
                AzureSiteRecoveryRecoveryPoints: {
                  value: '[parameters(\'AzureSiteRecoveryRecoveryPoints\')]'
                }
                AzureSiteRecoveryReplicationDataUploadRate: {
                  value: '[parameters(\'AzureSiteRecoveryReplicationDataUploadRate\')]'
                }
                AzureSiteRecoveryProtectedDiskDataChurn: {
                  value: '[parameters(\'AzureSiteRecoveryProtectedDiskDataChurn\')]'
                }
              }
            }
          }
        }
      }
    }
  }
}
