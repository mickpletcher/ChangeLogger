# Copilot Instructions

## Trigger: "commit my changes"

When the user types **commit my changes**, execute all steps below autonomously and in order.
Do not skip any step. Stop immediately if a safety check fails or if a git command returns an unexpected error. Some steps explicitly define acceptable nonzero command results.

This instruction file is a reusable template. It is not specific to any single project.
Drop it into any new repository and it works immediately.

---

## Step 1 — Run preflight checks

Run each of the following commands in the terminal and capture the output:

```bash
git status
git rev-parse --is-inside-work-tree
git rev-parse --abbrev-ref HEAD
git remote get-url origin
git ls-files .github/changelog-automation.md
git fetch --tags --quiet
git status --porcelain
```

If `.github/changelog-automation.md` exists, read it before continuing. Use it as repository-specific policy for protected branches, pull request requirements, validation commands, and version bump rules.

Store the following values for use in later steps:

| Variable | Source |
|---|---|
| `BRANCH` | Output of `git rev-parse --abbrev-ref HEAD` |
| `REMOTE_URL` | Output of `git remote get-url origin` |
| `POLICY_FILE` | Output of `git ls-files .github/changelog-automation.md` |
| `WORKTREE_STATUS` | Output of `git status --porcelain` |
| `TODAY` | Today's date in `YYYY-MM-DD` format |

Stop and report the exact error if:
- The current directory is not inside a git work tree
- `BRANCH` is `HEAD`
- `origin` is not configured
- `git fetch --tags --quiet` fails
- `WORKTREE_STATUS` contains likely secret files such as `.env`, `.env.local`, `.env.production`, `.npmrc`, `.pypirc`, `.netrc`, `.pem`, `.key`, `.p12`, `.pfx`, `id_rsa`, `id_ed25519`, `credentials.json`, or `service-account.json`
- There are unresolved merge conflicts

If `WORKTREE_STATUS` is empty, stop and report: `No changes detected. Nothing to commit.`

If GitHub CLI is installed and authenticated, optionally check whether `BRANCH` is protected before staging:

```bash
gh auth status
gh api "repos/{owner}/{repo}/branches/BRANCH/protection" --silent
```

Replace `BRANCH` with the current branch name, URL-encoding slashes if needed.

If the protection check succeeds, treat `BRANCH` as protected. Stop before committing or pushing unless `.github/changelog-automation.md` explicitly allows direct pushes to that branch. If the policy says pull requests are required and `BRANCH` is protected, stop and report that the user should switch to a feature branch before running the workflow.

---

## Step 2 — Stage and collect the diff

Stage all current workspace changes:

```bash
git add .
```

Then capture:

```bash
git diff --cached
git diff --cached --name-status
git describe --tags --abbrev=0 --match "v[0-9]*" --match "[0-9]*"
```

Store the following values for use in later steps:

| Variable | Source |
|---|---|
| `DIFF` | Output of `git diff --cached` |
| `STAGED_FILES` | Output of `git diff --cached --name-status` |
| `LAST_TAG` | Output of `git describe --tags --abbrev=0 --match "v[0-9]*" --match "[0-9]*"` |

If `DIFF` is empty after staging, stop and report: `No changes detected. Nothing to commit.`

If `git describe` fails or returns nothing, set `LAST_TAG` to `0.0.0`.

---

## Step 3 — Determine the next semantic version

Normalize `LAST_TAG` by removing a leading `v` if present. Using that normalized value as the current version, determine the next version based on the nature of the changes in `DIFF`.

If `.github/changelog-automation.md` defines version bump rules, follow those repository-specific rules. Otherwise, use these defaults:

| Change type | Bump | Example |
|---|---|---|
| Bug fixes, typo corrections, config tweaks, documentation updates | Patch | 0.1.0 → 0.1.1 |
| New features, new files, new functionality | Minor | 0.1.0 → 0.2.0 |
| Breaking changes, significant architectural changes | Major | 0.1.0 → 1.0.0 |

If `LAST_TAG` is `0.0.0` or does not exist, the next version is `0.1.0`.

Store this as `NEXT_VERSION`.
Store `vNEXT_VERSION` as `NEXT_TAG`.

Before continuing, verify that the new tag does not already exist:

```bash
git rev-parse -q --verify refs/tags/NEXT_TAG
```

If this command succeeds, stop and report: `Tag NEXT_TAG already exists.`
If this command fails because the tag does not exist, continue.

---

## Step 4 — Update CHANGELOG.md

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

## Step 5 — Build the commit message

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
Store the optional body as `COMMIT_BODY`.

---

## Step 6 — Run validation, commit, tag, and push

If `.github/changelog-automation.md` defines validation commands, run them before committing. Otherwise, if the repository has an obvious test, lint, or build command documented in `package.json`, `pyproject.toml`, `Cargo.toml`, `Makefile`, or the README, run the most relevant validation command before committing. If validation fails, stop and report the exact command and error.

If the repository policy says pull requests are required, do not push directly to a protected branch. Commit only on the current feature branch, push that branch and `NEXT_TAG` only if allowed by policy, then report that a pull request is required before merging or release publication.

Run the following commands in the terminal in this exact order:

```bash
git add CHANGELOG.md
git diff --cached --check
git commit -m "COMMIT_SUBJECT"
git tag NEXT_TAG
git push origin BRANCH
git push origin NEXT_TAG
```

Replace `COMMIT_SUBJECT`, `NEXT_TAG`, and `BRANCH` with the actual values from the previous steps.

If `COMMIT_BODY` is needed, replace the commit command above with:

```bash
git commit -m "COMMIT_SUBJECT" -m "COMMIT_BODY"
```

---

## Step 7 — Confirm completion

After all commands complete successfully, output a confirmation using exactly this format:

```
CHANGELOG.md updated - version NEXT_VERSION
Committed: COMMIT_SUBJECT
Tagged: NEXT_TAG
Pushed: BRANCH and NEXT_TAG
```

If any step fails, stop immediately, report the exact error message, and do not proceed to the next step.
