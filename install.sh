#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run this installer as root${NC}"
    exit 1
fi

echo -e "${YELLOW}[*] Starting ScanWise installation...${NC}"

# Update system
echo -e "${YELLOW}[*] Updating system packages...${NC}"
apt-get update
apt-get upgrade -y

# Install basic requirements
echo -e "${YELLOW}[*] Installing basic requirements...${NC}"
apt-get install -y python3 python3-pip git nmap nikto skipfish whatweb dnsrecon wapiti

# Install Python requirements
echo -e "${YELLOW}[*] Installing Python requirements...${NC}"
pip3 install -r requirements.txt

# Install RapidScan
echo -e "${YELLOW}[*] Installing RapidScan...${NC}"
if [ ! -d "/opt/rapidscan" ]; then
    git clone https://github.com/skavngr/rapidscan.git /opt/rapidscan
    ln -s /opt/rapidscan/rapidscan.py /usr/local/bin/rapidscan
    chmod +x /opt/rapidscan/rapidscan.py
fi

# Install w3af
echo -e "${YELLOW}[*] Installing w3af...${NC}"
if [ ! -d "/opt/w3af" ]; then
    git clone https://github.com/andresriancho/w3af.git /opt/w3af
    cd /opt/w3af
    ./w3af_console
    cd -
fi

# Set permissions
echo -e "${YELLOW}[*] Setting permissions...${NC}"
chmod +x scanwise.sh

echo -e "${GREEN}[✓] Installation completed!${NC}"
echo -e "${YELLOW}You can now run ScanWise using: sudo ./scanwise.sh${NC}"
