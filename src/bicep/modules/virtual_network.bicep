param addressPrefixes array
param name string
param flowTimeoutInMinutes int = 20
param location string = resourceGroup().location
param subnets array
param tags object = {}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'virtualNetworkDeployment'
  params: {
    // Required parameters
    name: name
    addressPrefixes: addressPrefixes
    // Non-required parameters
    // # diagnosticSettings: [
    // #   {
    // #     eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    // #     eventHubName: '<eventHubName>'
    // #     metricCategories: [
    // #       {
    // #         category: 'AllMetrics'
    // #       }
    // #     ]
    // #     name: 'customSetting'
    // #     storageAccountResourceId: '<storageAccountResourceId>'
    // #     workspaceResourceId: '<workspaceResourceId>'
    // #   }
    // # ]
    // # dnsServers: [
    // #   '10.0.1.4'
    // #   '10.0.1.5'
    // # ]
    flowTimeoutInMinutes: flowTimeoutInMinutes
    location: location
    subnets: subnets
    tags: tags
  }
}

output resourceId string = virtualNetwork.outputs.resourceId
