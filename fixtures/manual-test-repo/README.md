# Manual Test Fixture Repo

This folder describes a lightweight fixture repository you can create locally to manually validate the ChangeLogger workflow across common scenarios.

It is intentionally not a nested git repository in this template. Copy the files or commands below into a temporary folder and initialize git there.

## Create the Fixture

```bash
mkdir changelogger-fixture
cd changelogger-fixture
git init
git branch -M main
mkdir -p .github src tests
cp -R /path/to/ChangeLogger/fixtures/manual-test-repo/. .
cp /path/to/ChangeLogger/.github/copilot-instructions.md .github/copilot-instructions.md
git add .
git commit -m "chore(fixture): initial commit"
git tag v0.1.0
```

Add a local bare remote if you want to test push behavior:

```bash
cd ..
git init --bare changelogger-fixture-remote.git
cd changelogger-fixture
git remote add origin ../changelogger-fixture-remote.git
git push origin main --tags
```

## Scenarios

Use these manual scenarios with Copilot Chat.

| Scenario | Change to make | Expected result |
|---|---|---|
| Patch | Edit README wording | Patch version bump and `Changed` changelog entry |
| Minor | Add a new source file | Minor version bump and `Added` changelog entry |
| Major | Document a breaking behavior change | Major version bump or user prompt, depending on template |
| Secret guard | Add `.env` with placeholder content | Workflow stops before commit |
| Validation failure | Add invalid JavaScript to `src/app.js` | Validation fails before commit |
| Tag collision | Pre-create the expected next tag | Workflow stops with tag exists message |
| PR required | Add `.github/changelog-automation.md` with `pullRequestsRequired: true` | Workflow avoids direct protected branch push |

## Example Policy File

Copy `.github/changelog-automation.example.md` to `.github/changelog-automation.md` when you want to test pull-request-required behavior:

```bash
cp .github/changelog-automation.example.md .github/changelog-automation.md
```

```markdown
# Changelog Automation Policy

protectedBranches:
  - main

pullRequestsRequired: true
allowDirectPushesToProtectedBranches: false

validationCommands:
  - npm test
  - npm run lint
```
