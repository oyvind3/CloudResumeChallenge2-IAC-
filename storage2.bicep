param storageaccountname string = 'of${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
var filesharename = 'blob${uniqueString(resourceGroup().id)}'
var blobname = 'blob${uniqueString(resourceGroup().id)}'
var storageAccountHostName = replace(replace(stg2.properties.primaryEndpoints.blob, 'https://', ''), '/', '')

resource stg2 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageaccountname
  location: location
  tags: {
    test: storageaccountname
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
    customDomain: {
      name: 'test.finsrud.cloud'
    }
  }
}

resource storageAccounts_cloudresumeoyvind_name_default 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  parent: stg2
  name: blobname
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    changeFeed: {
      enabled: false
    }
    restorePolicy: {
      enabled: false
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
    isVersioningEnabled: false
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_cloudresumeoyvind_name_default 'Microsoft.Storage/storageAccounts/fileServices@2022-05-01' = {
  parent: stg2
  name: filesharename
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

output name1 string = storageaccountname
output test1 string = storageAccountHostName
output test2 string = storageAccountHostName

