// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
@description('Name of the Function App')
param name string

@description('Location to deploy the environment resources')
param location string = resourceGroup().location

@description('Tags to apply to environment resources')
param tags object = {}

// storage account names can be no longer than 24 chars,
// so if the provided name is logner, assume we trimmed it elsewhere
var storageAcctName = take(toLower(replace(replace(replace(name, ' ', ''), '-', ''), '_', '')), 24)

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAcctName
  location: location
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
  tags: tags
}
