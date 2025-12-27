#!/bin/bash
# Phase 4: Wazuh SIEM Server Setup
# Run on Ubuntu Server VM

set -e

echo "=== Phase 4: Wazuh SIEM Server Setup ==="

# Update system
echo "[1/4] Updating system packages..."
apt-get update && apt-get upgrade -y

# Install prerequisites
echo "[2/4] Installing prerequisites..."
apt-get install -y curl apt-transport-https lsb-release gnupg

# Download and run Wazuh installer
echo "[3/4] Installing Wazuh (all-in-one)..."
curl -sO https://packages.wazuh.com/4.9/wazuh-install.sh
chmod +x wazuh-install.sh
./wazuh-install.sh -a -i

# Extract credentials
echo "[4/4] Extracting dashboard credentials..."
tar -xvf wazuh-install-files.tar
cat wazuh-install-files/wazuh-passwords.txt > /home/vagrant/wazuh-credentials.txt
chown vagrant:vagrant /home/vagrant/wazuh-credentials.txt

# Get IP address for reference
IP_ADDR=$(hostname -I | awk '{print $1}')

echo ""
echo "=== Wazuh Installation Complete ==="
echo ""
echo "Dashboard URL: https://$IP_ADDR"
echo "Credentials saved to: /home/vagrant/wazuh-credentials.txt"
echo ""
echo "Next steps:"
echo "1. Access dashboard from browser"
echo "2. Deploy agents to DC01 and CLIENT01"
echo ""