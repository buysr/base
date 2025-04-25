param location string = resourceGroup().location
param name string
param virtualNetworkResourceId string
param disableCopyPaste bool = false
param enableFileCopy bool = false
param enableIpConnect bool = false
param enableShareableLink bool = false
param scaleUnits int = 4

@allowed(['Basic', 'Standard', 'Premium'])
param skuName string = 'Standard'

param tags object = {}

module bastionHost 'br/public:avm/res/network/bastion-host:0.6.1' = {
  name: 'bastionHostDeployment'
  params: {
    // Required parameters
    name: name
    virtualNetworkResourceId: virtualNetworkResourceId
    // Non-required parameters
    // # bastionSubnetPublicIpResourceId: '<bastionSubnetPublicIpResourceId>'
    // # diagnosticSettings: [
    // #   {
    // #     eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    // #     eventHubName: '<eventHubName>'
    // #     name: 'customSetting'
    // #     storageAccountResourceId: '<storageAccountResourceId>'
    // #     workspaceResourceId: '<workspaceResourceId>'
    // #   }
    // # ]
    disableCopyPaste: disableCopyPaste
    enableFileCopy: enableFileCopy
    enableIpConnect: enableIpConnect
    enableShareableLink: enableShareableLink
    location: location
    scaleUnits: scaleUnits
    skuName: skuName
    tags: tags
  }
}
