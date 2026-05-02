# Copilot Instructions - Fully Automated Workflow

## Trigger: "commit my changes"

When the user types **commit my changes**, execute the complete changelog, commit, tag, and push workflow without pausing, unless a safety check fails.

Use this template only for repositories where direct automation is acceptable.

---

## Required Steps

Run preflight checks:

```bash
git status
git rev-parse --is-inside-work-tree
git rev-parse --abbrev-ref HEAD
git remote get-url origin
git fetch --tags --quiet
git status --porcelain
```

Stop if the repository is invalid, detached, missing `origin`, clean, conflicted, or appears to include secret files.

Stage and inspect changes:

```bash
git add .
git diff --cached
git diff --cached --name-status
git describe --tags --abbrev=0 --match "v[0-9]*" --match "[0-9]*"
```

Determine the semantic version bump, update `CHANGELOG.md`, create a Conventional Commits message, run available validation, then run:

```bash
git add CHANGELOG.md
git diff --cached --check
git commit -m "COMMIT_SUBJECT"
git tag NEXT_TAG
git push origin BRANCH
git push origin NEXT_TAG
```

If a commit body is needed, use:

```bash
git commit -m "COMMIT_SUBJECT" -m "COMMIT_BODY"
```

---

## Output

After all commands succeed, report:

```text
CHANGELOG.md updated - version NEXT_VERSION
Committed: COMMIT_SUBJECT
Tagged: NEXT_TAG
Pushed: BRANCH and NEXT_TAG
```
