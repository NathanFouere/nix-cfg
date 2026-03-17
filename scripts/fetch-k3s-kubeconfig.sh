#!/usr/bin/env bash

# Script to fetch k3s kubeconfig from k3s-s VM and merge with local ~/.kube/config
# Usage: ./fetch-k3s-kubeconfig.sh [hostname-of-k3s-server]
# Default hostname for k3s server is 192.168.1.211

set -e

# Configuration
K3S_SERVER_HOST="${1:-192.168.1.211}"
THINKCENTRE_HOST="${THINKCENTRE_HOST:-thinkcentre-1}"
TEMP_DIR="/tmp/k3s-kubeconfig-$$"
LOCAL_KUBE_DIR="$HOME/.kube"
LOCAL_KUBECONFIG="$LOCAL_KUBE_DIR/config"
K3S_KUBECONFIG="$LOCAL_KUBE_DIR/config-k3s"
CERT_DIR="$LOCAL_KUBE_DIR/k3s-certificates"

echo "🚀 Fetching k3s kubeconfig from $K3S_SERVER_HOST..."

# Create temporary directory
mkdir -p "$TEMP_DIR"

# Check if we're on thinkcentre-1 or need to SSH
if [[ "$HOSTNAME" == *thinkcentre-1* ]]; then
    echo "✓ Already on thinkcentre-1"

    # Enter k3s-s VM and copy files
    echo "📦 Copying files from k3s-s VM..."
    sudo microvm enter vm-k3s-s -- sh -c "
        if [ -f /etc/rancher/k3s/k3s.yaml ]; then
            cat /etc/rancher/k3s/k3s.yaml
        else
            echo 'ERROR: k3s.yaml not found!' >&2
            exit 1
        fi
    " > "$TEMP_DIR/k3s.yaml"

    # Copy client certificates
    echo "📦 Copying client certificates..."
    sudo microvm enter vm-k3s-s -- sh -c "
        if [ -f /etc/rancher/k3s/client/admin.crt ] && [ -f /etc/rancher/k3s/client/admin.key ]; then
            cat /etc/rancher/k3s/client/admin.crt
            cat /etc/rancher/k3s/client/admin.key
        else
            echo 'WARNING: Client certificates not found!' >&2
        fi
    " > "$TEMP_DIR/client-certs.txt"

else
    echo "🔌 SSH-ing to thinkcentre-1..."

    # Enter k3s-s VM via SSH to thinkcentre-1 and copy files
    echo "📦 Copying files from k3s-s VM..."
    ssh "$THINKCENTRE_HOST" "sudo microvm enter vm-k3s-s -- sh -c '
        if [ -f /etc/rancher/k3s/k3s.yaml ]; then
            cat /etc/rancher/k3s/k3s.yaml
        else
            echo \"ERROR: k3s.yaml not found!\" >&2
            exit 1
        fi
    '" > "$TEMP_DIR/k3s.yaml"

    # Copy client certificates
    echo "📦 Copying client certificates..."
    ssh "$THINKCENTRE_HOST" "sudo microvm enter vm-k3s-s -- sh -c '
        if [ -f /etc/rancher/k3s/client/admin.crt ] && [ -f /etc/rancher/k3s/client/admin.key ]; then
            cat /etc/rancher/k3s/client/admin.crt
            cat /etc/rancher/k3s/client/admin.key
        else
            echo \"WARNING: Client certificates not found!\" >&2
        fi
    '" > "$TEMP_DIR/client-certs.txt"
fi

# Create local directories
mkdir -p "$LOCAL_KUBE_DIR"
mkdir -p "$CERT_DIR"

# Process client certificates
if grep -q "BEGIN CERTIFICATE" "$TEMP_DIR/client-certs.txt"; then
    echo "✓ Extracting client certificates..."

    # Split certificates (admin.crt and admin.key)
    awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' "$TEMP_DIR/client-certs.txt" > "$CERT_DIR/admin.crt"
    awk '/BEGIN.*PRIVATE KEY/,/END.*PRIVATE KEY/' "$TEMP_DIR/client-certs.txt" > "$CERT_DIR/admin.key"

    # Set proper permissions
    chmod 600 "$CERT_DIR/admin.key"
    chmod 644 "$CERT_DIR/admin.crt"

    echo "✓ Certificates saved to $CERT_DIR/"
else
    echo "⚠ No client certificates found, will use token authentication"
    CERT_DIR=""
fi

# Modify the kubeconfig to point to local paths
echo "🔧 Modifying kubeconfig paths..."

# Replace certificate paths with local paths (if certificates were found)
if [[ -n "$CERT_DIR" ]]; then
    sed -i "s|/etc/rancher/k3s/client|$CERT_DIR|g" "$TEMP_DIR/k3s.yaml"
fi

# Replace server CA certificate path (we'll skip TLS verification)
sed -i 's|certificate-authority: /etc/rancher/k3s/server/tls/client-ca.crt|insecure-skip-tls-verify: true|g' "$TEMP_DIR/k3s.yaml"

# Ensure server IP is correct (sometimes it's localhost in the VM)
sed -i "s|server: https://127.0.0.1:6443|server: https://$K3S_SERVER_HOST:6443|g" "$TEMP_DIR/k3s.yaml"

# Save the k3s kubeconfig
cp "$TEMP_DIR/k3s.yaml" "$K3S_KUBECONFIG"
chmod 600 "$K3S_KUBECONFIG"

echo "✓ Kubeconfig saved to $K3S_KUBECONFIG"

# Merge with main kubeconfig or create it
if [[ ! -f "$LOCAL_KUBECONFIG" ]]; then
    echo "📝 Creating new ~/.kube/config..."
    cp "$K3S_KUBECONFIG" "$LOCAL_KUBECONFIG"
    chmod 600 "$LOCAL_KUBECONFIG"
else
    echo "🔗 Merging with existing ~/.kube/config..."

    # Create a backup of existing config
    cp "$LOCAL_KUBECONFIG" "$LOCAL_KUBECONFIG.backup-$(date +%Y%m%d-%H%M%S)"

    # Use KUBECONFIG to merge both configs
    KUBECONFIG="$K3S_KUBECONFIG:$LOCAL_KUBECONFIG" kubectl config view --flatten > "$TEMP_DIR/merged.yaml"

    # Move merged config
    mv "$TEMP_DIR/merged.yaml" "$LOCAL_KUBECONFIG"
    chmod 600 "$LOCAL_KUBECONFIG"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Successfully fetched and configured k3s kubeconfig!"
echo ""
echo "📋 Next steps:"
echo "   Test the connection:"
echo "     kubectl get nodes --insecure-skip-tls-verify=true"
echo ""
echo "   Set k3s context (if not already default):"
echo "     kubectl config use-context default"
echo ""
echo "   To switch between clusters:"
echo "     kubectl config get-contexts"
echo "     kubectl config use-context <context-name>"
echo ""
