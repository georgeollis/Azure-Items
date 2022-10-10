targetScope = 'managementGroup'

resource AzurePolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'audit-storage-account-lifecycle-policy'
  properties: {
    displayName: 'Storage Accounts should have a Lifecycle Management Policy'
    description: 'This policy will audit storage accounts without a Lifecycle Management Policy'
    metadata:{
      Policy: 'Custom'
    }
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Storage/storageAccounts'
      }
      then: {
        effect: 'auditIfNotExists'
        details: {
          type: 'Microsoft.Storage/storageAccounts/managementPolicies'
          name: 'default'
          existenceCondition: {
            count: {
              field: 'Microsoft.Storage/storageAccounts/managementPolicies/policy.rules[*]'
              where: {
                field: 'Microsoft.Storage/storageAccounts/managementPolicies/policy.rules[*].type'
                equals: 'Lifecycle'
              }
            }
            greater: 0
          }
        }
      }
    }
  }
}
