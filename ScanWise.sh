#!/bin/bash

# Create the directory for saving reports if it doesn't exist
REPORT_DIR="ScanWise_Reports"
mkdir -p "$REPORT_DIR"

# Set up logging
LOG_FILE="$REPORT_DIR/scanwise.log"
exec 1> >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

# ANSI color codes and effects
BLINK="\e[5m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# Error handling
set -e
trap 'echo -e "${RED}[!] An error occurred. Exiting...${RESET}"; exit 1' ERR

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] This script must be run as root${RESET}"
    exit 1
fi

# Function to check dependencies
check_dependencies() {
    local tools=("nmap" "nikto" "skipfish" "whatweb" "dnsrecon" "wapiti")
    local missing=0

    echo -e "${YELLOW}[*] Checking dependencies...${RESET}"
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${RED}[!] Missing: $tool${RESET}"
            missing=1
        fi
    done

    if [ $missing -eq 1 ]; then
        echo -e "${RED}[!] Please run install.sh first${RESET}"
        exit 1
    fi

    echo -e "${GREEN}[✓] All dependencies are installed${RESET}"
}

# Function to display an animated banner
display_animated_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
    ███████╗ ██████╗ █████╗ ███╗   ██╗██╗    ██╗██╗███████╗███████╗
    ██╔════╝██╔════╝██╔══██╗████╗  ██║██║    ██║██║██╔════╝██╔════╝
    ███████╗██║     ███████║██╔██╗ ██║██║ █╗ ██║██║███████╗█████╗  
    ╚════██║██║     ██╔══██║██║╚██╗██║██║███╗██║██║╚════██║██╔══╝  
    ███████║╚██████╗██║  ██║██║ ╚████║╚███╔███╔╝██║███████║███████╗
    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝╚══════╝╚══════╝
EOF
    echo -e "${RESET}"
    echo -e "${CYAN}Developed by Ujjawal Tripathi (Cyber Security Researcher)${RESET}\n"
    echo -e "${YELLOW}[*] Starting scan at $(date)${RESET}\n"
    sleep 1
}

# Tool execution functions
run_nmap() {
    local target="$1"
    echo -e "${YELLOW}[+] Running Nmap Scan on $target...${RESET}"
    nmap -sV -sC -A -oN "$REPORT_DIR/nmap_scan.txt" "$target"
    echo -e "${GREEN}[✓] Nmap scan completed${RESET}"
}

run_nikto() {
    local target="$1"
    echo -e "${YELLOW}[+] Running Nikto Scan on $target...${RESET}"
    nikto -h "$target" -output "$REPORT_DIR/nikto_scan.txt"
    echo -e "${GREEN}[✓] Nikto scan completed${RESET}"
}

run_skipfish() {
    local target="$1"
    echo -e "${YELLOW}[+] Running Skipfish Scan on $target...${RESET}"
    skipfish -o "$REPORT_DIR/skipfish_scan" "$target"
    echo -e "${GREEN}[✓] Skipfish scan completed${RESET}"
}

run_rapidscan() {
    local target="$1"
    echo -e "${YELLOW}[+] Running Rapidscan on $target...${RESET}"
    rapidscan "$target" > "$REPORT_DIR/rapidscan_scan.txt"
    echo -e "${GREEN}[✓] Rapidscan completed${RESET}"
}

run_whatweb() {
    local target="$1"
    echo -e "${YELLOW}[+] Running WhatWeb Scan on $target...${RESET}"
    whatweb -v "$target" > "$REPORT_DIR/whatweb_scan.txt"
    echo -e "${GREEN}[✓] WhatWeb scan completed${RESET}"
}

run_dnsrecon() {
    local target="$1"
    echo -e "${YELLOW}[+] Running DNSRecon on $target...${RESET}"
    dnsrecon -d "$target" -o "$REPORT_DIR/dnsrecon_scan.txt"
    echo -e "${GREEN}[✓] DNSRecon scan completed${RESET}"
}

run_wapiti() {
    local target="$1"
    echo -e "${YELLOW}[+] Running Wapiti Scan on $target...${RESET}"
    wapiti -u "$target" -f txt -o "$REPORT_DIR/wapiti_scan.txt"
    echo -e "${GREEN}[✓] Wapiti scan completed${RESET}"
}

run_w3af() {
    local target="$1"
    echo -e "${YELLOW}[+] Running w3af Scan on $target...${RESET}"
    echo -e "plugins\noutput console,text_file\noutput config text_file\nset output_file $REPORT_DIR/w3af_scan.txt\nback\noutput config console\nset verbose False\nback\nhttp-settings\nset timeout 30\nback\ncrawl web_spider\naudit xss\nback\ntarget\nset target $target\nback\nstart\nexit" | w3af_console
    echo -e "${GREEN}[✓] w3af scan completed${RESET}"
}

run_all_scans() {
    local target="$1"
    run_nmap "$target"
    run_nikto "$target"
    run_skipfish "$target"
    run_rapidscan "$target"
    run_whatweb "$target"
    run_dnsrecon "$target"
    run_wapiti "$target"
    run_w3af "$target"
    echo -e "${GREEN}[✓] All scans completed successfully!${RESET}"
}

# Main menu
display_animated_banner
check_dependencies

while true; do
    echo -e "${CYAN}Select an option:${RESET}"
    echo "1. Run Nmap"
    echo "2. Run Nikto"
    echo "3. Run Skipfish"
    echo "4. Run Rapidscan"
    echo "5. Run WhatWeb"
    echo "6. Run DNSRecon"
    echo "7. Run Wapiti"
    echo "8. Run w3af"
    echo "9. Run All Scans"
    echo "0. Exit"
    read -p "Enter your choice: " choice

    case $choice in
        1) read -p "Enter target IP/Domain: " target; run_nmap "$target" ;;
        2) read -p "Enter target IP/Domain: " target; run_nikto "$target" ;;
        3) read -p "Enter target IP/Domain: " target; run_skipfish "$target" ;;
        4) read -p "Enter target IP/Domain: " target; run_rapidscan "$target" ;;
        5) read -p "Enter target IP/Domain: " target; run_whatweb "$target" ;;
        6) read -p "Enter target domain: " target; run_dnsrecon "$target" ;;
        7) read -p "Enter target URL: " target; run_wapiti "$target" ;;
        8) read -p "Enter target URL: " target; run_w3af "$target" ;;
        9) read -p "Enter target IP/Domain: " target; run_all_scans "$target" ;;
        0) echo "Exiting..."; exit 0 ;;
        *) echo -e "${RED}[!] Invalid option. Please try again.${RESET}" ;;
    esac
    read -p "Press [Enter] to continue..."
done
