# Ethical Hacking — Study Notes & Labs
> Personal, public study notes and lab materials for PJPT / PJWP — preparing for OSCP.  
> Author: Mozartopoulos — notes for personal study and (open) reference.  

[![Repo size](https://img.shields.io/github/repo-size/mozartopoulos/ethical-hacking)]()
[![Last commit](https://img.shields.io/github/last-commit/mozartopoulos/ethical-hacking)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)]()

---

## About
This repository contains my personal notes, lab walkthroughs, cheatsheets, scripts, and resources while studying penetration testing courses (TCM Security PJPT, PJWP) and planning to tackle OSCP in 2026. The purpose is to have organized, searchable notes that help retention and allow me to reproduce lab steps later.

**Status:** in progress — studying PJPT & PJWP for early 2026; OSCP planned for late 2026.

---

## Table of contents
- [Structure](#structure)
- [How I use these notes](#how-i-use-these-notes)
- [Contributing & fork policy](#contributing--forks)
- [Ethics, legality & safety](#ethics-legality--safety)
- [License](#license)
- [Useful links & resources](#useful-links--resources)

---

## Structure
/notes/ # course notes (markdown files)
/pjpt/
/pjwp/
/oscp/ # planning and eventual notes
/labs/ # lab writeups & exported VM notes (redacted)
/cheatsheets/ # quick commands, nmap lines, payloads (safe)
/scripts/ # personal helper scripts (annotated and safe)
/configs/ # useful configs (tmux, vim, burp, etc.)
/reports/ # sample pentest report templates (sanitized)
README.md
CONTRIBUTING.md
CODE_OF_CONDUCT.md


Guidelines:
- File names use `yyyy-mm-dd-topic.md` for chronological notes or `topic--short-title.md`.
- Keep lab IPs, credentials, and client-identifying info redacted. Prefer `127.0.0.1` / lab placeholders.

---

## How I use these notes
1. **Daily review** — short recap of concepts (15–30 minutes).  
2. **Hands-on** — follow up with a lab and write a short lab walkthrough in `/labs/`.  
3. **Cheatsheets** — distilled commands and techniques in `/cheatsheets/` for exam-time reference.  
4. **Report practice** — write a short report from each lab in `/reports/` to practice professional deliverables.

---

## Contributing & forks
This is primarily my personal study repo. You're welcome to fork and use the materials for your personal study. If you want to suggest edits or improvements, please open an issue or submit a PR. Contributions should:
- Focus on corrections, typos, improved explanations.
- Avoid adding real-world exploit code that could facilitate misuse.
- Respect the [Ethics & Legal](#ethics-legality--safety) section.

---

## Ethics, legality & safety
This repository is for **educational, authorized, and ethical** testing only. Do **not** use these techniques on systems you do not own or have explicit permission to test. Unauthorized access is illegal and unethical.

If you see content that could be abused, please report it via an issue and I will redact or rework it.

**Non-exhaustive safe-practices reminder:**
- Redact or omit real credentials and sensitive data.
- Use isolated lab environments (VMs, containers, intentionally vulnerable boxes).
- Prefer high-level descriptions and sanitized examples in public notes.

---

## License
MIT — see `LICENSE` file.

---

## Useful links & resources
- TCM Security course pages (PJPT / PJWP) — course materials used for notes.  
- Offensive Security (for OSCP prep).  
- [Kali Linux documentation], [Metasploit docs], [nmap docs], etc.

---

## Notes about safety & content
I avoided looking for or suggesting any potentially dangerous exploit code or step-by-step instructions to hack live systems. Keep your repo educational: high-level concepts, lab walkthroughs with redacted details, and clear ethical disclaimers.

# Instruction for new setup

After a brand new kali installation, update machine, install useful tools and setup aliases with the below:

```
sudo su -
git clone https://gitlab.com/mozartopoulos/ethical-hacking.git
chmod +x ethical-hacking/scripts/bootstrap.sh
./ethical-hacking/scripts/bootstrap.sh
```
## You are ready!
