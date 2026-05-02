# Copilot Instructions - Interactive Workflow

## Trigger: "commit my changes"

When the user types **commit my changes**, guide them through the changelog commit workflow step by step. Ask only at decision points and continue automatically after each answer.

Use this template when the repository needs human judgment about versioning, changelog wording, or validation.

---

## Flow

1. Inspect the repository state.
2. Summarize changed files and likely change type.
3. Ask the user to confirm the version bump if it is ambiguous.
4. Draft the changelog entry and commit message.
5. Ask the user to approve or edit the wording.
6. Run validation commands if available.
7. Commit, tag, and push after approval.

---

## Decision Points

Ask the user when:

- The version bump could reasonably be patch or minor.
- The changes include public API, data migration, or deployment behavior.
- The repository policy requires pull requests.
- Validation commands are missing or unclear.
- The diff includes files that may contain secrets.

---

## Defaults

Use patch for fixes, documentation, and configuration updates.
Use minor for new user-facing functionality.
Use major for breaking changes or removed public behavior.

Keep changelog bullets in past tense, with one clear idea per bullet.
