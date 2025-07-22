#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'
# more colors - https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
# Update and Upgrade Kali
echo -e "\n${RED}Updating and Upgrading Kali...\n${NC}"
apt update && apt upgrade -y
apt autoremove -y


# Install additional tools
echo -e "\n${RED}Installing additional tools for Kali...\n${NC}"
apt install gobuster -y
apt install dirsearch -y
apt install seclists -y
apt install tldr -y

# Setup aliases in .zshrc
echo -e "\n${RED}Putting handy aliases in kali user's .zshrc\n${NC}"
cd /home/kali
echo "alias c=clear" >> .zshrc
echo "alias q=exit" >> .zshrc
echo 'alias la="ls -lAh"' >> .zshrc
echo 'alias ll="ls -l"' >> .zshrc
echo 'alias l="ls -CF"' >> .zshrc
echo 'prettyjson="python3 -m json.tool"' >> .zshrc
source .zshrc
su kali
