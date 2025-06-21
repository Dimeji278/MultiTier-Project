#!/bin/bash

# Variables
RESOURCE_GROUP="Group5-MultiTier-RG"
LOCATION="eastus"

# NSG Names
NSG_WEB="Web-NSG"
NSG_APP="App-NSG"
NSG_DB="Db-NSG"

# Create resource group if it doesn't exist
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

# Create NSGs
echo "Creating NSGs..."
az network nsg create --resource-group "$RESOURCE_GROUP" --name "$NSG_WEB" --location "$LOCATION"
az network nsg create --resource-group "$RESOURCE_GROUP" --name "$NSG_APP" --location "$LOCATION"
az network nsg create --resource-group "$RESOURCE_GROUP" --name "$NSG_DB" --location "$LOCATION"

# Add NSG Rules
echo "Configuring NSG Rules..."

# Web-NSG: Allow HTTP and SSH
az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_WEB" --name Allow-HTTP --priority 100 --direction Inbound --access Allow --protocol Tcp --destination-port-ranges 80 --source-address-prefixes '*' --source-port-ranges '*'
az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_WEB" --name Allow-SSH --priority 110 --direction Inbound --access Allow --protocol Tcp --destination-port-ranges 22 --source-address-prefixes '*' --source-port-ranges '*'

# App-NSG: Allow SSH from Web subnet
az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_APP" --name AllowWebToAppSSH --priority 100 --direction Inbound --access Allow --protocol Tcp --destination-port-ranges 22 --source-address-prefixes 10.0.1.0/24 --source-port-ranges '*'
az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_APP" --name AllowSSHFromAnywhere --priority 105 --direction Inbound --access Allow --protocol Tcp --destination-port-ranges 22 --source-address-prefixes '*' --source-port-ranges '*'


# DB-NSG: Allow MySQL from App subnet
az network nsg rule create --resource-group "$RESOURCE_GROUP" --nsg-name "$NSG_DB" --name AllowAppToDbMySQL --priority 100 --direction Inbound --access Allow --protocol Tcp --destination-port-ranges 3306 --source-address-prefixes 10.0.2.0/24 --source-port-ranges '*'

# Associate NSGs with Subnets
echo "Associating NSGs with subnets..."

az network vnet subnet update --resource-group "$RESOURCE_GROUP" --vnet-name Group5-VNet --name Web-Subnet --network-security-group "$NSG_WEB"
az network vnet subnet update --resource-group "$RESOURCE_GROUP" --vnet-name Group5-VNet --name App-Subnet --network-security-group "$NSG_APP"
az network vnet subnet update --resource-group "$RESOURCE_GROUP" --vnet-name Group5-VNet --name DB-Subnet --network-security-group "$NSG_DB"

echo "✅ NSG setup complete."
