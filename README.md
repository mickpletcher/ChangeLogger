# ChangeLogger

ChangeLogger is a small PowerShell utility that generates a ready-to-paste GitHub Copilot Chat prompt for staging changes and creating a commit message.

The generated prompt tells Copilot to:

- run `git add .`
- inspect the staged changes
- summarize what changed
- suggest a conventional commit message
- output the git commit command

## What It Does

The script collects lightweight repository context, including:

- the current branch name
- the repository root
- the current git status
- the current date

It then builds a structured prompt that asks Copilot to:

1. run `git add .`
2. inspect the staged diff
3. ascertain what changed in the codebase
4. generate a commit message using conventional commit format

If clipboard access is available, the prompt is also copied automatically.

## Repository Layout

- `scripts/generate-changelog-prompt.ps1`: main script
- `vscode/tasks.json`: sample VS Code task definition for running the script

## Requirements

- Git installed and available in `PATH`
- PowerShell 7+ recommended
- GitHub Copilot Chat available in your editor

## Usage

Run the script from the repository root.

On macOS or Linux:

```bash
pwsh ./scripts/generate-changelog-prompt.ps1
```

On Windows PowerShell:

```powershell
.\scripts\generate-changelog-prompt.ps1
```

The script does not stage files itself. It generates a prompt that tells Copilot to run `git add .` and inspect the staged changes.

## Output

The script prints a full prompt that includes:

- repository context
- staging instructions
- change analysis instructions
- commit message rules
- a strict output template for Copilot to follow

The prompt instructs Copilot to return three sections:

- `STAGED CHANGES`
- `COMMIT MESSAGE`
- `GIT COMMANDS`

## Recommended Workflow

1. Make your code or documentation changes.
2. Run the script.
3. Paste the generated prompt into GitHub Copilot Chat.
4. Let Copilot stage the changes, inspect the diff, and suggest a commit message.
5. Review the suggested commit message before committing.

## VS Code Task

This repository includes [vscode/tasks.json](/Users/guypletcher/Documents/GitHub/ChangeLogger/vscode/tasks.json) with a task that runs [scripts/generate-changelog-prompt.ps1](/Users/guypletcher/Documents/GitHub/ChangeLogger/scripts/generate-changelog-prompt.ps1).

The checked-in task uses `pwsh`, which is appropriate for macOS and PowerShell 7 environments. If you use a different shell setup, adjust the task command for your local environment.

## Notes

- The script generates a prompt only; it does not execute git commands itself.
- The prompt is designed for an agent-capable Copilot Chat session that can run terminal commands.
- Commit message quality still depends on the staged diff and your review.