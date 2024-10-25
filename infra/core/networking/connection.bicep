param name string
param location string
param subnetId string
param networkingResourceGroupName string

resource connection 'Microsoft.DevCenter/networkConnections@2024-02-01' = {
  name: name
  location: location

  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: subnetId
    networkingResourceGroupName: '${networkingResourceGroupName}-networking'
  }
}

output id string = connection.id
output name string = connection.name
