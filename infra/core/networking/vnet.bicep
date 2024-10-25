param name string

param location string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

output id string = virtualNetwork.id
output subnetId string = virtualNetwork.properties.subnets[0].id
