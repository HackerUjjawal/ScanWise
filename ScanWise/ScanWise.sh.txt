#!/bin/bash

# Create the directory for saving reports if it doesn't exist
REPORT_DIR="ScanWise_Reports"
mkdir -p "$REPORT_DIR"

# Set up logging
LOG_FILE="$REPORT_DIR/scanwise.log"
exec > >(tee -a "$LOG_FILE")
exec 2> >(tee -a "$LOG_FILE" >&2)

# ANSI color codes and effects
BLINK="\e[5m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BLUE="\e[34m"
MAGENTA="\e[35m"
RESET="\e[0m"

# Function to format URL
format_url() {
    local input="$1"
    input="${input%/}"
    if [[ "$input" != http://* ]] && [[ "$input" != https://* ]]; then
        echo "http://$input"
    else
        echo "$input"
    fi
}

# Function to validate input
validate_input() {
    if [ -z "$1" ]; then
        echo -e "${RED}[!] Error: Target cannot be empty${RESET}"
        return 1
    fi
    return 0
}

# Function to display an attractive banner
display_banner() {
    clear
    echo -e "${BLUE}"
    echo "  ____                 __        ___           "
    echo " / ___|  ___ __ _ _ __\ \      / (_)___  ___   "
    echo " \___ \ / __/ _\` | '_ \\\\ \ /\ / /| / __|/ _ \  "
    echo "  ___) | (_| (_| | | | |\ V  V / | \__ \  __/  "
    echo " |____/ \___\__,_|_| |_| \_/\_/  |_|___/\___|  "
    echo -e "${RESET}"
    echo -e "${MAGENTA}Developed by Ujjawal Tripathi (Cyber Security Researcher)${RESET}"
    echo
    echo -e "${YELLOW}A comprehensive web application security scanner${RESET}"
    echo
}

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
        echo -e "${RED}[!] Please install missing tools before running this script${RESET}"
        exit 1
    fi

    echo -e "${GREEN}[✓] All dependencies are installed${RESET}"
}

# Function to run a scan with error handling
run_scan() {
    local tool="$1"
    local target="$2"
    local command="$3"
    
    echo -e "${YELLOW}[+] Starting $tool scan on $target...${RESET}"
    echo -e "${CYAN}[*] This may take some time. Please wait...${RESET}"
    
    if ! eval "$command"; then
        echo -e "${RED}[!] $tool scan failed. Check the log for details.${RESET}"
        return 1
    fi
    echo -e "${GREEN}[✓] $tool scan completed successfully${RESET}"
    return 0
}

# Scan functions
run_nmap() {
    if ! validate_input "$1"; then return 1; fi
    run_scan "Nmap" "$1" "nmap -sV -sC -A -oN '$REPORT_DIR/nmap_scan.txt' '$1'"
}

run_nikto() {
    if ! validate_input "$1"; then return 1; fi
    local target=$(format_url "$1")
    run_scan "Nikto" "$target" "nikto -h '$target' -output '$REPORT_DIR/nikto_scan.txt'"
}

run_skipfish() {
    if ! validate_input "$1"; then return 1; fi
    local target=$(format_url "$1")
    run_scan "Skipfish" "$target" "skipfish -o '$REPORT_DIR/skipfish_scan' '$target'"
}

run_whatweb() {
    if ! validate_input "$1"; then return 1; fi
    local target=$(format_url "$1")
    run_scan "WhatWeb" "$target" "whatweb -v '$target' > '$REPORT_DIR/whatweb_scan.txt'"
}

run_dnsrecon() {
    if ! validate_input "$1"; then return 1; fi
    run_scan "DNSRecon" "$1" "dnsrecon -d '$1' -t std,bing,yand,goog -o '$REPORT_DIR/dnsrecon_scan.txt'"
}

run_wapiti() {
    if ! validate_input "$1"; then return 1; fi
    local target=$(format_url "$1")
    run_scan "Wapiti" "$target" "wapiti -u '$target' -f txt -o '$REPORT_DIR/wapiti_scan.txt'"
}

run_all_scans() {
    if ! validate_input "$1"; then return 1; fi
    local target="$1"
    local formatted_target=$(format_url "$target")
    
    echo -e "${YELLOW}[*] Starting comprehensive scan on $target${RESET}"
    
    run_nmap "$target"
    run_nikto "$formatted_target"
    run_skipfish "$formatted_target"
    run_whatweb "$formatted_target"
    run_dnsrecon "$target"
    run_wapiti "$formatted_target"
    
    echo -e "${GREEN}[✓] Comprehensive scan completed!${RESET}"
    echo -e "${YELLOW}[*] Reports saved in: $REPORT_DIR${RESET}"
}

# Cleanup function
cleanup() {
    echo -e "\n${YELLOW}[*] Cleaning up...${RESET}"
    # Add any cleanup tasks here
    echo -e "${GREEN}[✓] Cleanup completed${RESET}"
    exit 0
}

# Trap Ctrl+C
trap cleanup SIGINT

# Main menu function
show_menu() {
    echo -e "${CYAN}Select an option:${RESET}"
    echo "1. Run Nmap"
    echo "2. Run Nikto"
    echo "3. Run Skipfish"
    echo "4. Run WhatWeb"
    echo "5. Run DNSRecon"
    echo "6. Run Wapiti"
    echo "7. Run All Scans"
    echo "0. Exit"
}

# Main program loop
main() {
    display_banner
    check_dependencies

    while true; do
        show_menu
        read -p "Enter your choice: " choice

        case $choice in
            1) 
                read -p "Enter target IP/Domain: " target
                run_nmap "$target"
                ;;
            2)
                read -p "Enter target IP/Domain: " target
                run_nikto "$target"
                ;;
            3)
                read -p "Enter target IP/Domain: " target
                run_skipfish "$target"
                ;;
            4)
                read -p "Enter target IP/Domain: " target
                run_whatweb "$target"
                ;;
            5)
                read -p "Enter target domain: " target
                run_dnsrecon "$target"
                ;;
            6)
                read -p "Enter target URL: " target
                run_wapiti "$target"
                ;;
            7)
                read -p "Enter target IP/Domain: " target
                run_all_scans "$target"
                ;;
            0)
                cleanup ;;
            *)
                echo -e "${RED}[!] Invalid option. Please try again.${RESET}"
                ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
        read
        display_banner
    done
}

# Start the program
main
