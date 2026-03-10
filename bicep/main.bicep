@description('Location for all resources')
param location string = resourceGroup().location

@description('Virtual Network Name')
param vnetName string = 'soc-lab-vnet'

@description('Subnet Name')
param subnetName string = 'soc-lab-subnet'

@description('Network Security Group Name')
param nsgName string = 'soc-lab-nsg'

@description('Virtual Machine Name')
param vmName string = 'attack-vm'

@description('Admin Username')
param adminUsername string = 'socadmin'

@secure()
@description('Admin Password')
param adminPassword string

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

// Subnet
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: '10.0.1.0/24'
  }
}

// Network Security Group
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// Public IP
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: '${vmName}-ip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnet.id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

//Creates a folder C:\Sysmon on the VM, downloads Sysmon, downloads the SwiftOnSecurity Sysmon config, installs Sysmon as a Windows service, then applies the configuration//

resource installSysmon 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: 'install-sysmon'
  parent: vm
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "mkdir C:\\Sysmon; cd C:\\Sysmon; Invoke-WebRequest https://download.sysinternals.com/files/Sysmon.zip -OutFile Sysmon.zip; Expand-Archive Sysmon.zip; Invoke-WebRequest https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml -OutFile sysmonconfig.xml; C:\\Sysmon\\Sysmon\\Sysmon64.exe -i sysmonconfig.xml -accepteula"'
    }
  }
}
// Deploy Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'soc-lab-law'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Deploy Microsoft Sentinel attached to the Log Analytics Workspace
resource sentinel 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: 'SecurityInsights(${logAnalytics.name})'
  location: location
  plan: {
    name: 'SecurityInsights(${logAnalytics.name})'
    product: 'OMSGallery/SecurityInsights'
    publisher: 'Microsoft'
    promotionCode: ''
  }
  properties: {
    workspaceResourceId: logAnalytics.id
  }
}


// Install Azure Monitor Agent (AMA) on the VM
// Connects VM telemetry to Log Analytics Workspace / Sentinel

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  name: 'AzureMonitorAgent'
  location: location
  parent: vm
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true 
settings: {
      workspaceId: logAnalytics.id
    }
  }
}

resource sysmonDcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' = {
  name: 'sysmon-dcr'
  location: location
  properties: {
    dataSources: {
      windowsEventLogs: [
        {
          name: 'sysmon-events'
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Microsoft-Windows-Sysmon/Operational!*'
          ]
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          name: 'law'
          workspaceResourceId: logAnalyticsWorkspace.id
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          'Microsoft-Event'
        ]
        destinations: [
          'law'
        ]
      }
    ]
  }
}

resource dcrAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'sysmon-dcr-association'
  scope: vm
  properties: {
    dataCollectionRuleId: sysmonDcr.id
  }
}
