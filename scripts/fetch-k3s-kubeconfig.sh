#!/usr/bin/env bash

# Vibecoded :-(
# Script to fetch k3s kubeconfig from k3s-s VM and set local ~/.kube/config

# Configuration from NixOS modules
THINKCENTRE_HOST="admin@thinkcentre-1"
K3S_VM_NAME="vm-k3s-s"
K3S_SERVER_IP="192.168.1.211"
K3S_SERVER_PORT="6443"
KUBECONFIG_LOCAL_PATH="$HOME/.kube/config-k3s"
KUBECONFIG_PATH="/etc/rancher/k3s/k3s.yaml"

echo "Fetching k3s kubeconfig from $THINKCENTRE_HOST/$K3S_VM_NAME..."

# Create local kube directory if needed
mkdir -p "$HOME/.kube"

# SSH to thinkcentre-1 then to k3s-s VM and fetch kubeconfig
echo "Copying k3s.yaml from $K3S_VM_NAME VM..."
ssh "$THINKCENTRE_HOST" "ssh  root@$K3S_SERVER_IP 'cat $KUBECONFIG_PATH'" > "$KUBECONFIG_LOCAL_PATH"

# Modify the kubeconfig to point to the correct server
echo "Modifying kubeconfig server address..."

# Replace server URL with the external IP (sometimes it's localhost in the VM)
sed -i "s|server: https://127.0.0.1:6443|server: https://$K3S_SERVER_IP:$K3S_SERVER_PORT|g" "$KUBECONFIG_LOCAL_PATH"

# Set proper permissions
chmod 600 "$KUBECONFIG_LOCAL_PATH"

echo "Kubeconfig saved to $KUBECONFIG_LOCAL_PATH"
