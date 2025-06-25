#!/bin/bash


# init Network Infra Variables
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

echo "Creating Resource Group: $RESOURCE_GROUP..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Creating Virtual Network: $VNET_NAME with $SUBNET_WEB..."
az network vnet create \
  --resource-group $RESOURCE_GROUP \
  --name $VNET_NAME \
  --address-prefix $VNET_PREFIX \
  --subnet-name $SUBNET_WEB \
  --subnet-prefix $WEB_PREFIX

echo "Creating $SUBNET_APP subnet..."
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET_APP \
  --address-prefix $APP_PREFIX

echo "Creating $SUBNET_DB subnet..."
az network vnet subnet create \
  --resource-group $RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $SUBNET_DB \
  --address-prefix $DB_PREFIX

echo "🎉 Network setup complete!"



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

echo "NSG setup complete."


# Variables
VNET_NAME="Group5-VNet"
ADMIN_USER="azureuser"
VM_SIZE="Standard_B1s"
SSH_KEY_PATH="$HOME/.ssh/id_rsa.pub"
IMAGE="Ubuntu2204"

# Web VM
echo "Creating Web VM in Web-Subnet..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name webVM \
  --image "$IMAGE" \
  --size "$VM_SIZE" \
  --admin-username "$ADMIN_USER" \
  --ssh-key-values "$SSH_KEY_PATH" \
  --vnet-name "$VNET_NAME" \
  --subnet "Web-Subnet" \
  --public-ip-sku Standard \
  --no-wait

# App VM
echo "Creating App VM in App-Subnet..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name appVM \
  --image "$IMAGE" \
  --size "$VM_SIZE" \
  --admin-username "$ADMIN_USER" \
  --ssh-key-values "$SSH_KEY_PATH" \
  --vnet-name "$VNET_NAME" \
  --subnet "App-Subnet" \
  --public-ip-sku Standard \
  --no-wait

# DB VM
echo "Creating DB VM in DB-Subnet..."
az vm create \
  --resource-group "$RESOURCE_GROUP" \
  --name dbVM \
  --image "$IMAGE" \
  --size "$VM_SIZE" \
  --admin-username "$ADMIN_USER" \
  --ssh-key-values "$SSH_KEY_PATH" \
  --vnet-name "$VNET_NAME" \
  --subnet "DB-Subnet" \
  --public-ip-sku Standard \
  --no-wait

echo "VM provisioned."




