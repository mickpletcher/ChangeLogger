# Copilot Instructions - Cautious Workflow

## Trigger: "commit my changes"

When the user types **commit my changes**, prepare the changelog, version, commit message, tag, and push plan, but ask for explicit confirmation before each destructive or publishing action.

Use this template for repositories where safety matters more than speed.

---

## Required Confirmations

Ask before running each action:

- `git add .`
- Creating or editing `CHANGELOG.md`
- `git commit`
- `git tag`
- `git push`

Before asking, show:

- Current branch
- Changed files
- Proposed version bump
- Proposed changelog entry
- Proposed commit subject
- Proposed tag
- Proposed push target

Stop if the user says no, cancel, stop, or asks to change the plan.

---

## Safety Checks

Run:

```bash
git status
git rev-parse --is-inside-work-tree
git rev-parse --abbrev-ref HEAD
git remote get-url origin
git status --porcelain
```

Stop if:

- The directory is not a git work tree
- The branch is detached
- `origin` is missing
- No changes are detected
- Likely secret files are present
- Merge conflicts are present

Likely secret files include `.env`, `.npmrc`, `.pypirc`, `.netrc`, private keys, certificate files, credential JSON files, and service account files.

---

## Output

After the user approves and commands succeed, report:

```text
CHANGELOG.md updated - version NEXT_VERSION
Committed: COMMIT_SUBJECT
Tagged: NEXT_TAG
Pushed: BRANCH and NEXT_TAG
```
