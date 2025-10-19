# Reconnaissance Tools — Quick Reference

## Email & identity discovery
- **Hunter (hunter.io)** — find email patterns for domains.  
- **Phonebook.cz** — OSINT people search / contact info.  
- **VoilaNorbert (voilanorbert.com)** — email finding service.  
- **Clearbit Connect (Chrome extension)** — lookup email & company info from the inbox.  
- **Email Checker / Verifiers**
  - `email-checker.net` — verify deliverability / format.  
  - `tools.verifyemailadress.io` — additional verification checks.  
- **Manual checks**
  - Try discovered addresses on provider login pages (e.g., Gmail) — check sign-in / "forgot password" flows and account recovery hints (lab / authorized testing only).  
  - Search for linked accounts (social media, GitHub, LinkedIn).

---

## Breach & password/credential sources (research only — do not download/use stolen data)
- **GitHub** — e.g., user/project references (example: `hmaverickadams` / `breach-parse`) — *do not download or use breached data*.  
- **DeHashed** — searchable breach database (use responsibly).  
- **Hashes.org** — hash/crack research resource.

---

## Subdomain / certificate / host discovery
- **crt.sh** — certificate transparency lookup for domain-subdomain enumeration.  
- **OWASP Amass** — active/passive subdomain enumeration and asset discovery.  
- **Sublist3r** — subdomain enumeration (install: `apt install sublist3r` or use pip repo).  
- **TomNomNom httprobe** — probe for alive HTTP hosts from a list of domains (`httprobe`).

---

## Web technology & fingerprinting
- **BuiltWith (builtwith.com)** — tech stack identification for domains.  
- **Wappalyzer (Firefox extension)** — browser extension to detect technologies.  
- **WhatWeb** — command-line web fingerprinting tool.

---

## Web proxy & manual testing
- **Burp Suite** — intercepting proxy for active web testing, request manipulation, and scanning.

---

## OSINT / general search
- **Google Fu / Search Operators** — advanced search queries (`site:`, `inurl:`, `filetype:`, etc.) to find exposed files, endpoints, or info.  
- **Maltego** — graphical OSINT link analysis and relationship discovery.

---

## Quick usage tips
- Combine passive sources first (crt.sh, builtwith, amass passive mode) before any noisy or authenticated checks.  
- Always validate discovered emails/hosts in isolated environments or with explicit permission.  
- Keep a redaction habit: when saving screenshots or exporting results, redact real user identifiers and breached data before committing anything public.  
- Chain tools: e.g., `amass`/`sublist3r` → deduplicate → `httprobe` for alive hosts → `gobuster`/`ffuf` for content discovery.

---

## References & notes
- Install or update tools via your package manager or official repos. Some tools have better versions via `pip`, `go get`, or their GitHub releases.  
- Maintain a local, private archive of any sensitive findings — do **not** publish breached credentials or sensitive dumps.
