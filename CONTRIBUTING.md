# Contributing Guidelines

Thank you for your interest in contributing to this repository!  
This project is primarily a **personal study repo**, but improvements that help clarity, correctness, and usability are welcome.  
Please read and follow these guidelines before opening issues or pull requests.

---

## 🧭 How to Contribute

### 1. Issues
- Use issues to report bugs, suggest improvements, or ask questions about the content.  
- Provide a clear title and a concise description of the problem or suggestion.  
- When relevant, include:
  - File name or section reference.
  - Expected and actual behavior.
  - Suggested fix or wording (if applicable).

### 2. Pull Requests (PRs)
- Fork the repo and create a branch on your fork:  
  ```bash
  git checkout -b fix/short-description
- Make small, focused commits with clear messages.
- Push the branch and open a PR against main on the upstream repository.
- In your PR description, include:
- What you changed and why.
- References to related issues (e.g., Fixes #12).
- Screenshots or examples if relevant.

### 3. Code & Content Standards

- Keep all content educational and safe — avoid adding anything that could be used for unauthorized or malicious purposes.
- Do not add credentials, live exploit payloads, or real-world identifying data.
- Use redacted, lab-based examples (e.g., LAB-BOX, 10.10.10.10).
- Keep Markdown clean and readable (80–100 character lines recommended).

### 4. File Naming & Structure

Follow the existing organization:
/notes/           → study and reference notes
/labs/            → sanitized lab write-ups
/cheatsheets/     → quick commands and references
/scripts/         → helper scripts (safe only)

Use yyyy-mm-dd-topic.md or topic--short-title.md naming for easy sorting.

### 5. Tests & Checks

- This repo mainly contains documentation, so automated tests are minimal.
- If you add scripts, include short usage notes and ensure they’re safe in isolated lab environments.
- Markdown files may be linted (markdownlint) and link-checked automatically via CI.

### 6. Review Process

- PRs will be reviewed by the repository owner. Expect friendly, constructive feedback.
- The owner may request small changes before merging.
- If your PR is declined, you’ll receive feedback explaining why.

## ⚖️ License & Attribution

By contributing, you agree that your contributions will be licensed under the repository’s license (MIT by default).
If you include third-party content, make sure it’s compatible with MIT and properly attributed.

## 🙌 Thank You

Thanks for taking the time to help improve this project!
Contributions that improve clarity, fix typos, or add safe educational examples are always appreciated.
