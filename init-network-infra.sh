#!/bin/bash


# Variables
RESOURCE_GROUP="Group5-MultiTier-RG"
LOCATION="eastus"
VNET_NAME="Group5-VNet"
SUBNET_WEB="Web-Subnet"
SUBNET_APP="App-Subnet"
SUBNET_DB="DB-Subnet"

# Address prefixes
VNET_PREFIX="10.0.0.0/16"
WEB_PREFIX="10.0.1.0/24"
APP_PREFIX="10.0.2.0/24"
DB_PREFIX="10.0.3.0/24"

echo "✅ Creating Resource Group: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "✅ Creating Virtual Network: $VNET_NAME with $SUBNET_WEB..."
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix $VNET_PREFIX \
  --subnet-name $SUBNET_WEB \
  --subnet-prefix $WEB_PREFIX

echo "✅ Creating $SUBNET_APP subnet..."
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET_APP \
  --address-prefix $APP_PREFIX

echo "✅ Creating $SUBNET_DB subnet..."
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET_DB \
  --address-prefix $DB_PREFIX

echo "🎉 Network setup complete!"