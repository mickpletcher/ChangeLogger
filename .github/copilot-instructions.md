# Copilot Instructions

## Trigger: "commit my changes"

When the user types **commit my changes**, execute all steps below autonomously and in order.
Do not ask for confirmation. Do not pause between steps. Do not skip any step.

This instruction file is a reusable template. It is not specific to any single project.
Drop it into any new repository and it works immediately.

---

## Step 1 — Collect workspace context

Run each of the following commands in the terminal and capture the output:

```bash
git status
```

If there are unstaged changes, stage everything first:

```bash
git add .
```

Then capture the full staged diff:

```bash
git diff --cached
```

Also capture:

```bash
git rev-parse --abbrev-ref HEAD
git describe --tags --abbrev=0
git diff --cached --name-status
```

Store the following values for use in later steps:

| Variable | Source |
|---|---|
| `DIFF` | Output of `git diff --cached` |
| `BRANCH` | Output of `git rev-parse --abbrev-ref HEAD` |
| `LAST_TAG` | Output of `git describe --tags --abbrev=0` — use `0.0.0` if command fails or returns nothing |
| `STAGED_FILES` | Output of `git diff --cached --name-status` |
| `TODAY` | Today's date in `YYYY-MM-DD` format |

If `DIFF` is empty after staging, stop and report: `No changes detected. Nothing to commit.`

---

## Step 2 — Determine the next semantic version

Using `LAST_TAG` as the current version, determine the next version based on the nature of the changes in `DIFF`:

| Change type | Bump | Example |
|---|---|---|
| Bug fixes, typo corrections, config tweaks, documentation updates | Patch | 0.1.0 → 0.1.1 |
| New features, new files, new functionality | Minor | 0.1.0 → 0.2.0 |
| Breaking changes, significant architectural changes | Major | 0.1.0 → 1.0.0 |

If `LAST_TAG` is `0.0.0` or does not exist, the next version is `0.1.0`.

Store this as `NEXT_VERSION`.

---

## Step 3 — Update CHANGELOG.md

### Check if CHANGELOG.md exists

**If CHANGELOG.md does not exist**, create it in the repository root with exactly this content and nothing else:

```
# Changelog

All notable changes to this project will be documented in this file.
This project adheres to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

```

**If CHANGELOG.md already exists**, leave all existing content intact. Do not modify, remove, or reformat anything already in the file.

### Insert the new entry

In both cases, insert the new changelog entry directly below the header block and above any existing entries.

Use exactly this format:

```
## [NEXT_VERSION] - TODAY
_Branch: BRANCH_

### SECTION
- Past tense bullet describing the change
- Additional bullet if needed
```

**Section rules:**
- `SECTION` must be exactly one of: `Added`, `Changed`, `Fixed`, `Removed`, `Security`, `Deprecated`
- Use multiple section headers if the diff spans more than one type of change
- List each section header only once, group all related bullets under it
- Bullets must be written in past tense
- One clear idea per bullet, maximum 15 words per bullet
- Maximum 5 bullets total across all sections
- No file paths, file names, or code syntax in bullets
- Describe the purpose and effect of the change, not the implementation detail

**Save the file.**

---

## Step 4 — Build the commit message

Analyze `DIFF` and `STAGED_FILES` and produce a commit message using exactly this format:

```
type(scope): short imperative subject line

Optional body paragraph explaining what changed and why.
Wrap all lines at 72 characters maximum.
```

**Rules:**
- `type` must be exactly one of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`
- `scope`: single lowercase word or short hyphenated phrase inferred from the file paths in `STAGED_FILES`
- `subject`: imperative mood, no capital first letter, no trailing period, maximum 72 characters
- `body`: only include if the subject line alone does not fully explain the reason for the change
- Breaking changes: append `!` after the closing parenthesis and add a `BREAKING CHANGE:` footer after the body

Store the subject line as `COMMIT_SUBJECT`.

---

## Step 5 — Run the git commands

Run the following commands in the terminal in this exact order:

```bash
git add CHANGELOG.md
git commit -m "COMMIT_SUBJECT"
git tag vNEXT_VERSION
git push origin BRANCH --tags
```

Replace `COMMIT_SUBJECT`, `NEXT_VERSION`, and `BRANCH` with the actual values from the previous steps.

---

## Step 6 — Confirm completion

After all commands complete successfully, output a confirmation using exactly this format:

```
✓ CHANGELOG.md updated — version NEXT_VERSION
✓ Committed: COMMIT_SUBJECT
✓ Tagged: vNEXT_VERSION
✓ Pushed to BRANCH
```

If any step fails, stop immediately, report the exact error message, and do not proceed to the next step.