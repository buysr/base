param vnetName string = 'vnet-entraid-bastion-weu-01'
param bastionName string = 'bastion-entraid-bastion-weu-01'
param location string = resourceGroup().location
param addressPrefixes array = [
  '10.0.0.0/16'
]
param subnets array = [
  {
    name: 'virtualMachines'
    addressPrefix: '10.0.1.0/24'
  }
]
param flowTimeoutInMinutes int = 20
param disableCopyPaste bool = false
param enableFileCopy bool = false
param enableIpConnect bool = false
param enableShareableLink bool = false
param scaleUnits int = 4
param skuName string = 'Standard'
param tags object = {}

module VNET './modules/virtual_network.bicep' = {
  params: {
    name: vnetName
    addressPrefixes: addressPrefixes
    location: location
    subnets: subnets
    flowTimeoutInMinutes: flowTimeoutInMinutes
    tags: tags
  }
}

module VM './modules/virtual_machine.bicep' = {
  params: {
    
    virtualNetworkResourceId: VNET.outputs.resourceId
  }
}

module Bastion './modules/bastion.bicep' = {
  params: {
    name: bastionName
    location: location
    disableCopyPaste: disableCopyPaste
    enableFileCopy: enableFileCopy
    enableIpConnect: enableIpConnect
    enableShareableLink: enableShareableLink
    scaleUnits: scaleUnits
    skuName: skuName
    virtualNetworkResourceId: VNET.outputs.resourceId
  }
}
