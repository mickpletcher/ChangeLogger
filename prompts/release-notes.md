# Release Notes Prompt

Use this companion prompt when you want release notes without staging, committing, tagging, or pushing changes.

## Trigger: "draft release notes"

When the user types **draft release notes**, inspect the repository history and current changes, then draft release notes only. Do not modify files. Do not run `git add`, `git commit`, `git tag`, or `git push`.

---

## Collect Context

Run:

```bash
git status
git rev-parse --abbrev-ref HEAD
git describe --tags --abbrev=0 --match "v[0-9]*" --match "[0-9]*"
git log --oneline --decorate --max-count=20
git diff --stat
git diff
```

If no previous tag exists, summarize from the beginning of the repository history.

---

## Draft Format

Produce:

```markdown
# Release Notes - VERSION

## Highlights

- Short user-facing summary of the most important change.
- Additional highlight if useful.

## Changes

### Added
- New capabilities or content.

### Changed
- Updated behavior or documentation.

### Fixed
- Bug fixes or corrections.

## Upgrade Notes

- Migration, configuration, or compatibility notes.
```

Omit empty sections. Keep the tone user-facing and avoid implementation-only details.
