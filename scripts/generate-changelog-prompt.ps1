<#
.SYNOPSIS
    Generates a GitHub Copilot prompt that updates CHANGELOG.md and produces a commit message.

.DESCRIPTION
    Captures the current git diff, branch, last tag, and staged files, then builds a
    complete prompt ready to paste into GitHub Copilot Chat. Copilot will update
    CHANGELOG.md and output the commit message and git commands.

.EXAMPLE
    .\New-ChangelogPrompt.ps1
    Outputs the full prompt to the terminal. Copy and paste into Copilot Chat.

.NOTES
    Run after: git add .
    Requires:  Git installed and available in PATH
#>

[CmdletBinding()]
param ()

#region Functions

function Write-Log {
    param (
        [string]$Message,
        [ValidateSet('INFO', 'WARN', 'ERROR')]
        [string]$Level = 'INFO'
    )
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] [$Level] $Message"
}

function Get-GitValue {
    param (
        [string[]]$Arguments,
        [string]$Fallback = ''
    )
    try {
        $result = & git @Arguments 2>$null
        if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($result)) {
            return $Fallback
        }
        return $result
    }
    catch {
        return $Fallback
    }
}

#endregion Functions

#region Main

try {
    Write-Log 'Collecting git context...'

    $diff      = Get-GitValue -Arguments @('diff', '--cached') -Fallback ''
    $branch    = Get-GitValue -Arguments @('rev-parse', '--abbrev-ref', 'HEAD') -Fallback 'main'
    $lastTag   = Get-GitValue -Arguments @('describe', '--tags', '--abbrev=0') -Fallback 'none'
    $staged    = Get-GitValue -Arguments @('diff', '--cached', '--name-status') -Fallback 'none'
    $today     = Get-Date -Format 'yyyy-MM-dd'

    if ([string]::IsNullOrWhiteSpace($diff)) {
        Write-Log 'No staged changes detected. Run git add . first.' -Level WARN
        exit 1
    }

    Write-Log 'Building Copilot prompt...'

    $prompt = @"
You are an experienced software developer maintaining a clean and professional git repository history.

I have staged changes in my repository. You must do two things:

1. Update CHANGELOG.md with a new entry at the top of the file (below the header line if one exists).
2. Output a git commit message and the exact git commands to run.

=======================================================
REPO CONTEXT
=======================================================
Today's date : $today
Branch       : $branch
Last tag     : $lastTag

Staged files :
$staged

Git diff :
``````
$diff
``````

=======================================================
RULE 1 — CHANGELOG.md UPDATE
=======================================================
Open the file CHANGELOG.md in this workspace and insert the following entry at the top,
below any existing header. Do not remove or modify any existing content.

Use exactly this format:

## [VERSION] - $today
_Branch: $branch_

### SECTION
- Past tense bullet describing the change (max 15 words)
- Additional bullet if needed

Rules:
- VERSION: infer from the nature of the changes
  - Patch (e.g. 0.1.1): bug fixes, typo corrections, docs updates, config tweaks
  - Minor (e.g. 0.2.0): new features, new files, new functionality
  - Major (e.g. 1.0.0): breaking changes or significant architectural changes
  - Default to 0.1.0 if no prior version exists
- SECTION must be one of: Added, Changed, Fixed, Removed, Security, Deprecated
- Use multiple sections if the diff spans more than one change type
- Bullets must be past tense, one idea each, max 15 words, max 5 bullets total
- No file paths, file names, or language-specific syntax in bullets

=======================================================
RULE 2 — COMMIT MESSAGE
=======================================================
Use exactly this format:

type(scope): short imperative subject line

Optional body paragraph if the subject alone does not fully explain the change.
Wrap lines at 72 characters.

Rules:
- type: feat, fix, docs, style, refactor, perf, test, chore, ci, build
- scope: single lowercase word or short hyphenated phrase inferred from the file paths
- subject: imperative mood, no capital first letter, no period, max 72 characters
- Breaking changes: append ! after closing parenthesis and add BREAKING CHANGE: footer

=======================================================
RULE 3 — OUTPUT FORMAT
=======================================================
Return exactly this structure and nothing else:

---
### ACTION TAKEN
Briefly confirm that CHANGELOG.md was updated and what version was applied.

---
### COMMIT MESSAGE
[commit message here]

---
### GIT COMMANDS
``````bash
git add CHANGELOG.md
git commit -m "subject line from above"
git tag vX.X.X
git push origin $branch --tags
``````
"@

    Write-Log 'Prompt ready. Copy everything between the lines below and paste into Copilot Chat.'
    Write-Host ''
    Write-Host ('=' * 60)
    Write-Host $prompt
    Write-Host ('=' * 60)
    Write-Host ''
    Write-Log 'Done.'

    # Copy to clipboard if running interactively
    try {
        $prompt | Set-Clipboard
        Write-Log 'Prompt also copied to clipboard.'
    }
    catch {
        Write-Log 'Clipboard copy skipped (not available in this environment).' -Level WARN
    }
}
catch {
    Write-Log "Unexpected error: $_" -Level ERROR
    exit 1
}

#endregion Main
