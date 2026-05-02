# GitHub Copilot Changelog Automation

[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=for-the-badge&logo=github)](https://github.com/mickpletcher/ChangeLogger/generate)

ChangeLogger is a reusable GitHub Copilot instruction kit for turning a simple Copilot Chat request into a consistent changelog, semantic version, commit, tag, and push workflow.

It is designed for teams and solo developers who want every repository to follow the same release-style commit habit without maintaining scripts in every project.

## What This Project Provides

This repository includes:

| Path | Purpose |
|---|---|
| `.github/copilot-instructions.md` | Default Copilot repository instructions for changelog, commit, tag, and push workflows. |
| `templates/cautious/copilot-instructions.md` | Alternate workflow that asks before staging, committing, tagging, or pushing. |
| `templates/interactive/copilot-instructions.md` | Alternate workflow that asks at judgment points such as version bump and changelog wording. |
| `templates/fully-automated/copilot-instructions.md` | Alternate workflow that runs end to end after safety checks pass. |
| `prompts/release-notes.md` | Companion prompt for drafting release notes without modifying files or publishing anything. |
| `fixtures/manual-test-repo/` | Lightweight fixture project for manually testing the workflow across common scenarios. |
| `future-updates.md` | Roadmap of completed and possible future improvements. |
| `CHANGELOG.md` | Version history for this template repository. |

## Important Concept

This is not a shell script or GitHub Action.

GitHub Copilot repository instructions are context that Copilot Chat can use when responding inside a repository. This project gives Copilot a clear workflow to follow, but Copilot still runs inside your editor experience and may vary based on your client, model, settings, repository state, and permissions.

Review Copilot's terminal actions and generated text the same way you would review any agent-assisted git operation.

## Default Workflow

When you type:

```text
commit my changes
```

Copilot is instructed to:

1. Check the git repository, current branch, remote, and working tree state.
2. Load optional repository policy from `.github/changelog-automation.md` if present.
3. Stop if the repo is unsafe to continue, such as detached `HEAD`, missing remote, merge conflicts, or likely secret files.
4. Stage current workspace changes.
5. Read the staged diff.
6. Determine the next semantic version.
7. Create or update `CHANGELOG.md`.
8. Generate a Conventional Commits style commit message.
9. Run validation commands if available.
10. Commit the changes.
11. Create a version tag.
12. Push the branch and tag, unless repository policy requires a pull request flow.

## Requirements

You need:

- Visual Studio Code
- GitHub Copilot subscription
- GitHub Copilot Chat enabled in VS Code
- Git installed and available in the terminal
- A git repository with an `origin` remote if you want Copilot to push
- Permission to commit, tag, and push to the repository

Optional but useful:

- GitHub CLI, `gh`, for protected branch checks
- Project test, lint, or build commands
- Secret scanning or pre-commit hooks for sensitive repositories

## Repository Structure

The minimum setup in a target repository is:

```text
repo/
└── .github/
    └── copilot-instructions.md
```

For stricter repositories, you can also add:

```text
repo/
└── .github/
    ├── copilot-instructions.md
    └── changelog-automation.md
```

## Quick Start With This Template

Use this repository as a GitHub template when creating new repositories:

1. Open this repository on GitHub.
2. Click **Use this template**.
3. Create your new repository.
4. Confirm the new repository includes `.github/copilot-instructions.md`.
5. Open the new repository in VS Code.
6. Make a normal code or documentation change.
7. Open GitHub Copilot Chat.
8. Type `commit my changes`.

Copilot should follow the repository instructions and guide or perform the changelog commit workflow.

## Add ChangeLogger to an Existing Repository

From the root of an existing repository, run:

```bash
mkdir -p .github
curl -L https://raw.githubusercontent.com/mickpletcher/ChangeLogger/main/.github/copilot-instructions.md -o .github/copilot-instructions.md
git add .github/copilot-instructions.md
git commit -m "chore(copilot): add changelog automation instructions"
```

If you do not want to use `curl`:

1. Create `.github/copilot-instructions.md`.
2. Copy the contents of this repository's `.github/copilot-instructions.md`.
3. Paste and save the file.
4. Commit it to the target repository.

## Choose a Workflow Template

The default template balances automation with guardrails. If a repository needs a different style, copy one of the alternate templates into the target repository as `.github/copilot-instructions.md`.

| Template | Best for | Behavior |
|---|---|---|
| `.github/copilot-instructions.md` | General use | Runs the workflow with safety checks and policy awareness. |
| `templates/cautious/copilot-instructions.md` | Sensitive repos | Requires approval before staging, changelog edits, commits, tags, and pushes. |
| `templates/interactive/copilot-instructions.md` | Repos needing human judgment | Asks at decision points such as version bump, wording, validation, and PR requirements. |
| `templates/fully-automated/copilot-instructions.md` | Low-risk automation | Runs end to end unless a safety check fails. |

Example:

```bash
mkdir -p .github
cp templates/interactive/copilot-instructions.md .github/copilot-instructions.md
```

Then commit the selected instruction file.

## Verify Copilot Loaded the Instructions

Open Copilot Chat in VS Code and ask:

```text
What repository instructions are active for this workspace?
```

Copilot should reference `.github/copilot-instructions.md` or describe the changelog commit workflow.

If it does not:

- Confirm the file is named exactly `.github/copilot-instructions.md`.
- Confirm the repository root is open in VS Code.
- Confirm GitHub Copilot Chat is enabled and signed in.
- Save the instruction file and reopen Copilot Chat.
- Restart VS Code if Copilot still does not appear to pick up the file.

## Daily Usage

A normal usage flow looks like this:

1. Make your code or documentation changes.
2. Run any local checks you normally run.
3. Open Copilot Chat in VS Code.
4. Type:

   ```text
   commit my changes
   ```

5. Watch Copilot inspect the repository and staged diff.
6. Review the changelog entry and commit message.
7. Confirm any prompts if you are using the cautious or interactive template.
8. Check the final output for version, commit, tag, and push status.

## Example Output

After a successful run, Copilot should report something like:

```text
CHANGELOG.md updated - version 0.2.1
Committed: docs(readme): clarify changelog workflow
Tagged: v0.2.1
Pushed: main and v0.2.1
```

## Example Changelog Entry

The generated `CHANGELOG.md` entry should be inserted near the top:

```markdown
## [0.2.1] - 2026-05-01
_Branch: main_

### Changed
- Clarified Copilot instructions as guided workflow context
- Hardened commit workflow with preflight checks and safer tag pushes
```

The exact version, date, branch, section, and bullets should match the committed changes.

## Versioning Rules

By default, ChangeLogger uses semantic versioning:

| Change type | Version bump | Example |
|---|---|---|
| Fixes, typo corrections, config tweaks, documentation updates | Patch | `0.1.0` to `0.1.1` |
| New features, new files, new functionality | Minor | `0.1.0` to `0.2.0` |
| Breaking changes or significant architecture changes | Major | `0.1.0` to `1.0.0` |

If no version tag exists, the first generated version is `0.1.0`.

Tags may use either `0.1.0` or `v0.1.0`. The default instruction template normalizes both forms before calculating the next version, then creates tags in `vNEXT_VERSION` form.

## Changelog Rules

Generated changelog entries follow this shape:

```markdown
## [NEXT_VERSION] - TODAY
_Branch: BRANCH_

### SECTION
- Past tense bullet describing the change
- Additional bullet if needed
```

Section names must be one of:

- `Added`
- `Changed`
- `Fixed`
- `Removed`
- `Security`
- `Deprecated`

The default instruction template asks Copilot to:

- Preserve existing changelog content.
- Insert the new entry below the header and above older entries.
- Use past tense.
- Keep bullets short.
- Avoid file paths and implementation-only details in changelog bullets.

## Commit Message Rules

The default instruction template asks Copilot to create a Conventional Commits style message:

```text
type(scope): short imperative subject line

Optional body paragraph explaining what changed and why.
```

Allowed types:

- `feat`
- `fix`
- `docs`
- `style`
- `refactor`
- `perf`
- `test`
- `chore`
- `ci`
- `build`

Example:

```text
docs(readme): add usage guide for changelog automation
```

## Optional Repository Policy

For stricter repositories, create `.github/changelog-automation.md` in the target repository.

Copilot is instructed to read this file before staging, committing, tagging, or pushing. Use it to document repo-specific rules:

```markdown
# Changelog Automation Policy

protectedBranches:
  - main
  - release/*

pullRequestsRequired: true
allowDirectPushesToProtectedBranches: false

validationCommands:
  - npm test
  - npm run lint

versionBumpRules:
  patch:
    - documentation updates
    - dependency pin changes
  minor:
    - new user-facing functionality
    - new public configuration options
  major:
    - breaking API changes
    - removed public behavior
```

This policy file is optional. If it is not present, the template uses the defaults in `.github/copilot-instructions.md`.

## Validation Commands

The instruction template tries to run relevant test, lint, or build commands before committing when they are obvious. For best results, make them explicit in `.github/changelog-automation.md`.

### Node.js

```markdown
validationCommands:
  - npm test
  - npm run lint
  - npm run build
```

### Python

```markdown
validationCommands:
  - python -m pytest
  - python -m ruff check .
  - python -m build
```

### .NET

```markdown
validationCommands:
  - dotnet test
  - dotnet format --verify-no-changes
  - dotnet build --configuration Release
```

Keep validation commands fast enough to run during a commit workflow. Long deployment, integration, or release checks usually belong in CI.

## Protected Branches and Pull Requests

If GitHub CLI is installed and authenticated, the default instruction template asks Copilot to check whether the current branch is protected before staging changes.

When protection is detected, Copilot should stop before committing or pushing unless the optional policy file explicitly allows direct pushes.

For repositories that require pull requests:

1. Work on a feature branch instead of `main`.
2. Set `pullRequestsRequired: true` in `.github/changelog-automation.md`.
3. Keep `allowDirectPushesToProtectedBranches: false`.
4. Ask Copilot to commit on the feature branch.
5. Push the feature branch.
6. Open a pull request through your normal review process.

Avoid direct tag publication from protected or release-managed branches unless your project policy explicitly allows it.

## Secret Detection Guidance

The default instruction template stops if the working tree appears to include common credential files, including:

- `.env`
- `.env.local`
- `.env.production`
- `.npmrc`
- `.pypirc`
- `.netrc`
- `.pem`
- `.key`
- `.p12`
- `.pfx`
- `id_rsa`
- `id_ed25519`
- `credentials.json`
- `service-account.json`

Also review diffs manually for inline secrets:

- API keys
- Bearer tokens
- GitHub tokens
- npm or PyPI tokens
- Cloud provider credentials
- Deployment tokens
- Private keys
- Database URLs with usernames and passwords
- Webhook signing secrets

Secret detection here is only a guardrail. Sensitive repositories should also use dedicated secret scanning, pre-commit hooks, and branch protection.

## Release Notes Without Committing

Use `prompts/release-notes.md` when you want release notes without modifying files or publishing anything.

In Copilot Chat:

1. Paste the contents of `prompts/release-notes.md`.
2. Type:

   ```text
   draft release notes
   ```

The prompt tells Copilot to inspect git history and current diffs, draft user-facing release notes, and avoid:

- `git add`
- `git commit`
- `git tag`
- `git push`

## Manual Fixture Testing

The `fixtures/manual-test-repo` folder contains a small Node-based fixture for validating the workflow manually.

It includes:

- `package.json` with `test`, `lint`, and `build` commands
- `src/app.js`
- `.github/changelog-automation.example.md`
- A scenario checklist in `fixtures/manual-test-repo/README.md`

To create a temporary fixture repository:

```bash
mkdir changelogger-fixture
cd changelogger-fixture
git init
git branch -M main
cp -R /path/to/ChangeLogger/fixtures/manual-test-repo/. .
cp /path/to/ChangeLogger/.github/copilot-instructions.md .github/copilot-instructions.md
git add .
git commit -m "chore(fixture): initial commit"
git tag v0.1.0
```

To test push behavior:

```bash
cd ..
git init --bare changelogger-fixture-remote.git
cd changelogger-fixture
git remote add origin ../changelogger-fixture-remote.git
git push origin main --tags
```

Manual scenarios to try:

| Scenario | Change to make | Expected result |
|---|---|---|
| Patch | Edit README wording | Patch version bump and `Changed` changelog entry |
| Minor | Add a new source file | Minor version bump and `Added` changelog entry |
| Major | Document a breaking behavior change | Major version bump or user prompt, depending on template |
| Secret guard | Add `.env` with placeholder content | Workflow stops before commit |
| Validation failure | Add invalid JavaScript to `src/app.js` | Validation fails before commit |
| Tag collision | Pre-create the expected next tag | Workflow stops with tag exists message |
| PR required | Add `.github/changelog-automation.md` with `pullRequestsRequired: true` | Workflow avoids direct protected branch push |

## Troubleshooting

| Problem | What to check |
|---|---|
| Copilot ignores `commit my changes` | Confirm `.github/copilot-instructions.md` exists, is saved, and the repo root is open in VS Code. |
| Copilot does not mention repository instructions | Ask Copilot what repository instructions are active, then restart VS Code if needed. |
| `No changes detected. Nothing to commit.` | Run `git status` and confirm there are modified, added, or deleted files. |
| `origin` is not configured | Add a remote with `git remote add origin <repo-url>`. |
| Branch is detached | Check out a normal branch before running the workflow. |
| Protected branch check stops the workflow | Switch to a feature branch or update `.github/changelog-automation.md` if direct pushes are allowed. |
| Tag already exists | Fetch tags and choose whether the next version should be bumped again. |
| Push is rejected | Pull or rebase the latest remote branch, resolve conflicts, then run the workflow again. |
| Secret-file check stops the workflow | Remove credentials or move them to ignored local files before committing. |
| Validation fails | Fix the failing test, lint, or build command before asking Copilot to commit again. |

## Recommended Rollout

For a team, use this rollout path:

1. Add the default `.github/copilot-instructions.md` to one low-risk repository.
2. Run the manual fixture scenarios locally.
3. Add `.github/changelog-automation.md` with explicit validation commands.
4. Decide whether your team needs cautious, interactive, or fully automated behavior.
5. Add the chosen template to additional repositories.
6. Review the first few Copilot-generated changelog entries and commits.
7. Adjust version bump rules and validation commands as needed.

## Limitations

ChangeLogger cannot guarantee:

- Copilot will behave identically in every client or model.
- Every secret will be detected.
- Every version bump will match your release policy without repository-specific guidance.
- Pushes will succeed against branch protection, permissions, or remote state.
- Tests will be discovered correctly if they are not documented or configured.

Treat this project as a strong workflow guide for Copilot, not a replacement for repository permissions, CI, code review, or release governance.

## License

This project is licensed under the MIT License. See `LICENSE` for details.
