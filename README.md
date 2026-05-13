# 🚀 advrelease

A **modern, interactive, and production-ready CLI tool** for automated semantic versioning, Git tagging, and GitHub releases.

Built for developers who want a fast, clean, and reliable release workflow directly from the terminal.

---

## ✨ Features

* ⚡ Interactive CLI (arrow-key selection via TUI)
* 🧠 Semantic versioning support (major / minor / patch)
* 🧪 Dry-run mode for safe testing
* 📦 Automatic `composer.json` version update
* 🏷️ Git tagging automation
* 🚀 Git push + GitHub release automation
* 🔐 GitHub CLI auto-install & authentication check
* 🧼 Clean DevOps-style output (minimal, structured logs)
* 🖥️ Works in SSH, WSL, Linux, macOS terminals

---

## 📸 Preview

```
advrelease v1.0.0 by Usman Saif

01 Validating repository
   ✓ Repository verified

02 Checking working tree
   ! Uncommitted changes detected

03 Calculating next version
   ✓ Next: v0.1.8

04 Publishing release
   → git push origin master
   → git push origin v0.1.8
   ✓ GitHub release created
```

---

## ⚡ Quick Start

Just add `release.sh` into your project root and start automatically managing semantic versioning.

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/usmansaif/semantic-version-release-cli/master/release.sh -o release.sh

# Make it executable
chmod +x release.sh

# Run it!
./release.sh
```

---

## 📦 Installation

### 1. Clone repository

```bash
git clone https://github.com/usmansaif/semantic-version-release-cli.git
cd advrelease
chmod +x release.sh
```

---

## 🚀 Usage

### Interactive mode (recommended)

```bash
./release.sh
```

Use arrow keys to select release type:

* Major
* Minor
* Patch
* Dry Run

---

### CLI mode

```bash
./release.sh --patch
./release.sh --minor
./release.sh --major
```

---

### Dry run (safe mode)

```bash
./release.sh --patch --dry-run
```

---

## ⚙️ Requirements

* Git
* Bash (4+ recommended)
* GitHub CLI (`gh`) *(auto-installed if missing)*
* Composer (optional, if using PHP projects)

---

## 🔐 GitHub Authentication

The tool automatically checks your authentication status. If not already authenticated, it will guide you through the process:

```text
04 Authenticating GitHub
? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: XXXX-XXXX
Press Enter to open https://github.com/login/device in your browser... 
Opening in existing browser session.
✓ Authentication complete.
- gh config set -h github.com git_protocol https
✓ Configured git protocol
✓ Logged in as usmansaif
   ✓ GitHub authenticated
```

---

## 🧠 How it works

1. Validates Git repository
2. Checks working directory status
3. Fetches latest Git tags
4. Calculates next semantic version
5. Updates `composer.json` (if exists)
6. Creates Git commit (version bump)
7. Creates Git tag
8. Pushes branch + tag
9. Publishes GitHub release

---

## 🏆 Best Practices

* **Auto Authentication**: Log in once with your GitHub account for a completely automated release flow.
* **Hassle-Free Versioning**: Use the interactive UI for a smooth, mistake-proof experience.
* **Verify First**: Utilize the dry-run mode to confirm version bumps before they go live.
* **Repository Health**: Always start with a clean working tree for the most reliable results.

---

## 🧪 Dry Run Mode

Test everything without making changes:

```bash
./release.sh --patch --dry-run
```

Safe for CI validation and testing workflows.

---

## 📂 Project Structure

```
advrelease/
 ├── release.sh
 ├── README.md
 └── LICENSE
```

---

## 🔧 Roadmap

* [ ] Changelog auto-generation
* [ ] Conventional commits parser
* [ ] Plugin system (pre/post hooks)
* [ ] JSON/YAML config support
* [ ] Multi-language project support
* [ ] CI/CD GitHub Actions integration

---

## 👤 Author

**Usman Saif**
- Email: [usman.saif22@gmail.com](mailto:usman.saif22@gmail.com)
- Website: https://usmansaif.com
- GitHub: https://github.com/usmansaif/

---

## ⭐ Support

If you find this tool useful, consider giving it a star ⭐ on GitHub.

---

## 📜 License

MIT License — free to use and modify.

