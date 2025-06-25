#!/bin/bash
# Variables
RESOURCE_GROUP="Group5-MultiTier-RG"
VNET_NAME="Group5-VNet"
LOCATION="eastus"
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

echo "VM provisioning initiated."
