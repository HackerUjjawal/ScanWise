# ScanWise - Automated Security Scanning Tool

<p align="center">
  <img src="ScanWise.png" alt="ScanWise Logo" width="200"/>
</p>

## Description

ScanWise is an automated security scanning tool that combines multiple popular security scanning tools into a single, easy-to-use interface. Developed by Ujjawal Kumar Tripathi, this tool streamlines the process of conducting security assessments by providing a centralized platform for running various types of scans.

## Features

- **Multiple Scanning Tools Integration:**
  - Nmap (Network scanning)
  - Nikto (Web server scanning)
  - Skipfish (Web application security scanning)
  - WhatWeb (Website fingerprinting)
  - DNSRecon (DNS reconnaissance)
  - Wapiti (Web application vulnerability scanning)

- **Automated Reporting:**
  - Generates detailed reports for each scan
  - Saves all results in organized directories
  - Maintains logs of all operations

- **User-Friendly Interface:**
  - Interactive menu system
  - Clear status indicators
  - Progress tracking for each scan

## Prerequisites

- Operating System: Linux (Debian-based distributions recommended)
- Root privileges
- Required tools:
  - nmap
  - nikto
  - skipfish
  - whatweb
  - dnsrecon
  - wapiti
  
## Future Improvements

- Add more scanning tools
- Implement concurrent scanning
- Add HTML report generation
- Create a GUI interface
- Add scan scheduling functionality
- Implement result analysis and recommendations

## Note :- Run This Tool As Root User Only

## Disclaimer
This tool is for educational and ethical testing purposes only. The developer assumes no liability for misuse or damage caused by this program. Always ensure you have explicit permission to scan any systems or networks.

## Author
Ujjawal Kumar Tripathi
( Cyber Security Researcher )

## Acknowledgments
Thanks to all the developers of the tools integrated into ScanWise
Special thanks to the security research community

## Version History
v1.0.0
- Initial release
- Basic scanning functionality
- Support for 6 security tools

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/scanwise.git
cd scanwise
chmod +x install.sh scanwise.sh
sudo ./install.sh
sudo ./scanwise.sh
