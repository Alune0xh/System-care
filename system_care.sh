#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

disk_threshold=80
memory_threshold=85
cores=$(nproc)
load_threshold=$(echo "$cores * 1.2 "| bc -l)
file_log=$HOME/systemcare.log

load_1m=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ') 

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

warnings=()

disk_free=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [[ $disk_free -gt $disk_threshold ]]; then
    warnings+=("Disk usage is at ${disk_free}% (threshold ${disk_threshold}%)")
fi 

Total=$(free -m | awk 'NR==2 {print $2}')
Used=$(free -m | awk 'NR==2 {print $3}')
memory_percent=$(( 100 * Used / Total))

if [[ $memory_percent -gt $memory_threshold ]]; then
    warnings+=("Memory usage is at ${memory_percent}% (threshold ${memory_threshold}%)")
fi

if (( $(echo "$load_1m > $load_threshold" | bc -l) )); then
    warnings+=("Load average is ${load_1m} (threshold ${load_threshold})")
fi

echo -e "${BOLD}${CYAN}System care check${RESET} $(timestamp)"
echo -e "  Disk usage:   ${disk_free}%"
echo -e "  Memory usage: ${memory_percent}%"
echo -e "  Load average: ${load_1m}"
echo ""

if [[ ${#warnings[@]} -eq 0 ]]; then
    echo -e "${GREEN}✓ All clear${RESET}"
else
    echo -e "${RED}⚠ Warnings:${RESET}"
    for i in "${warnings[@]}"; do
        echo -e "  ${YELLOW}- $i${RESET}"
    done
fi

echo "$(timestamp) disk=${disk_free}% mem=${memory_percent}% load=${load_1m} warnings=${#warnings[@]}" >> "$file_log"