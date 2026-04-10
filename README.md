# GitHub Copilot Changelog Automation

A reusable GitHub Copilot instruction template that automates changelog updates and git commits across any repository. Type a single phrase in Copilot Chat and it handles everything automatically.

---

## What It Does

When you type **commit my changes** in GitHub Copilot Chat, Copilot will:

1. Stage all unstaged changes
2. Read the git diff from the workspace
3. Determine the correct semantic version bump
4. Create or update `CHANGELOG.md` with a formatted entry
5. Generate a Conventional Commits formatted commit message
6. Commit, tag, and push to the remote repository

No scripts. No copy and paste. No manual git commands.

---

## Repository Structure

```
repo/
└── .github/
    └── copilot-instructions.md
```

---

## Setup Instructions

### Step 1 — Create a GitHub Template Repository

1. Go to [github.com](https://github.com) and click **+** in the top right corner
2. Select **New repository**
3. Name it something like `repo-template`
4. Set visibility to **Private**
5. Check **Add a README file**
6. Click **Create repository**

### Step 2 — Mark It as a Template

1. Inside the new repo click **Settings**
2. Scroll to the **General** section
3. Check the box labeled **Template repository**
4. Click **Save**

### Step 3 — Add the Instruction File

1. Inside the repo click **Add file** and select **Create new file**
2. In the filename field type exactly:
   ```
   .github/copilot-instructions.md
   ```
   GitHub will automatically create the `.github` folder when you include the `/` in the name
3. Paste the contents of `copilot-instructions.md` from this repo into the editor
4. Click **Commit changes**

### Step 4 — Use the Template for Every New Repo

When creating any new repository going forward:

1. Click **+** and select **New repository**
2. At the top where it says **Repository template** select your template repo from the dropdown
3. The `.github/copilot-instructions.md` file is automatically copied into the new repo

---

## How to Use It

1. Make your changes in the repo
2. Open GitHub Copilot Chat in VS Code with `Cmd+Shift+I` (Mac) or `Ctrl+Shift+I` (Windows)
3. Type: `commit my changes`
4. Copilot handles everything from that point forward

---

## Important Notes

**This file is per repo, not global.**
The `copilot-instructions.md` file only applies when that specific repo is open in VS Code. Using a GitHub template repo ensures the file is present in every new project automatically without any extra steps.

**CHANGELOG.md is created automatically.**
If `CHANGELOG.md` does not exist in the repo root, Copilot creates it with the proper Keep a Changelog header before inserting the first entry. If it already exists, existing content is never modified or removed.

**Versioning starts at 0.1.0.**
If no version tags exist in the repo, the first commit is tagged as `v0.1.0`. Every subsequent commit increments the version based on the nature of the changes:

| Change type | Version bump | Example |
|---|---|---|
| Bug fixes, config tweaks, documentation updates | Patch | 0.1.0 to 0.1.1 |
| New features, new files, new functionality | Minor | 0.1.0 to 0.2.0 |
| Breaking changes, significant architectural changes | Major | 0.1.0 to 1.0.0 |

---

## Requirements

- Visual Studio Code
- GitHub Copilot subscription
- Git installed and available in your terminal
- Repository must have a remote origin configured for the push step to succeed