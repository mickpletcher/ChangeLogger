# GitHub Copilot Changelog Automation

[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge&logo=github)](https://github.com/mickpletcher/ChangeLogger/generate)

A reusable GitHub Copilot instruction template that guides changelog updates, semantic versioning, commits, tags, and pushes across repositories. Type a single phrase in Copilot Chat to start a consistent release-style commit workflow.

---

## What It Does

When you type **commit my changes** in GitHub Copilot Chat, Copilot is instructed to:

1. Check the repository, branch, remote, and working tree state
2. Stage the current workspace changes after safety checks
3. Determine the correct semantic version bump
4. Create or update `CHANGELOG.md` with a formatted entry
5. Generate a Conventional Commits formatted commit message
6. Commit, tag, and push the branch plus the new tag

No scripts and no copy/paste workflow. Copilot still runs inside your editor experience, so review its terminal actions and output the same way you would review any agent-assisted git operation.

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

## Add to an Existing Repo

From the root of an existing repository, run:

```bash
mkdir -p .github
curl -L https://raw.githubusercontent.com/mickpletcher/ChangeLogger/main/.github/copilot-instructions.md -o .github/copilot-instructions.md
git add .github/copilot-instructions.md
git commit -m "chore(copilot): add changelog automation instructions"
```

If you prefer not to use `curl`, create `.github/copilot-instructions.md` manually and paste in the instruction file from this template.

---

## How to Use It

1. Make your changes in the repo
2. Open GitHub Copilot Chat in VS Code with `Cmd+Shift+I` (Mac) or `Ctrl+Shift+I` (Windows)
3. Type: `commit my changes`
4. Review the completed changelog entry, commit, tag, and push result

---

## Verify Copilot Loaded the Instructions

Ask Copilot Chat:

```text
What repository instructions are active for this workspace?
```

Copilot should reference `.github/copilot-instructions.md` or describe the changelog commit workflow. If it does not, check that:

- The file is named exactly `.github/copilot-instructions.md`
- The repository root is open in VS Code
- GitHub Copilot Chat is enabled and signed in
- The file was saved before opening the chat

---

## Example Changelog Entry

After a successful run, `CHANGELOG.md` should receive a new entry near the top:

```markdown
## [0.2.1] - 2026-05-01
_Branch: main_

### Changed
- Clarified Copilot instructions as guided workflow context
- Hardened commit workflow with preflight checks and safer tag pushes
```

The exact version, date, branch, section, and bullets should match the repository changes Copilot committed.

---

## Troubleshooting

| Problem | What to check |
|---|---|
| Copilot ignores `commit my changes` | Confirm the instruction file is saved under `.github/copilot-instructions.md` and reopen Copilot Chat. |
| `No changes detected. Nothing to commit.` | Run `git status` and confirm there are modified, added, or deleted files in the repository. |
| `origin` is not configured | Add a remote with `git remote add origin <repo-url>` before asking Copilot to push. |
| Tag already exists | Fetch tags, inspect the existing tag, and choose whether the next version should be bumped again. |
| Push is rejected | Pull or rebase the latest remote branch, resolve conflicts, then run the workflow again. |
| Secret-file check stops the workflow | Review the flagged file and remove credentials before committing. |

---

## Important Notes

**This file is per repo, not global.**
The `copilot-instructions.md` file only applies when that specific repo is open in VS Code. Using a GitHub template repo ensures the file is present in every new project automatically without any extra steps.

**Repository instructions guide Copilot; they do not create a deterministic script.**
GitHub Copilot includes repository custom instructions as context for supported features. The template is designed to make the requested workflow consistent, but Copilot's exact behavior may vary by client, model, repository state, and settings.

**CHANGELOG.md is created automatically.**
If `CHANGELOG.md` does not exist in the repo root, Copilot creates it with the proper Keep a Changelog header before inserting the first entry. If it already exists, existing content is never modified or removed.

**Versioning starts at 0.1.0.**
If no version tags exist in the repo, the first commit is tagged as `v0.1.0`. Existing tags may use either `0.1.0` or `v0.1.0`; the instruction template normalizes both forms before calculating the next version. Every subsequent commit increments the version based on the nature of the changes:

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
- A clean understanding of which local changes should be included before asking Copilot to commit
