@description('Create a new catalog in the specified Dev Center')
param devCenterName string

@description('The name of the devbox definition to create in the specified Dev Center')
param name string

@description('DevBox definition SKU.')
param definitionSKU string = 'general_i_8c32gb256ssd_v2'
@description('DevBox definition storage type.')
param definitionStorageType string = 'ssd_256gb'

@description('The location of the devbox definition to create in the specified Dev Center')
param location string

resource devcenter 'Microsoft.DevCenter/devcenters@2023-04-01' existing = {
  name: devCenterName
}

resource devboxdefinition 'Microsoft.DevCenter/devcenters/devboxdefinitions@2023-04-01' = {
  name: name
  location: location

  parent: devcenter

  properties: {
    hibernateSupport: 'Enabled'
    imageReference: {
      id: '${devcenter.id}/galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2'
    }
    sku: {
      name: definitionSKU
    }
    osStorageType: definitionStorageType
  }
}

output name string = devboxdefinition.name
