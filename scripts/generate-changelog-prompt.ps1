<#
.SYNOPSIS
    Generates a GitHub Copilot prompt for staging changes and creating a commit message.

.DESCRIPTION
    Builds a ready-to-paste prompt that asks GitHub Copilot Chat to run `git add .`,
    inspect the staged changes, determine what changed, and generate a conventional
    commit message.

.EXAMPLE
    .\generate-changelog-prompt.ps1
    Outputs the full prompt to the terminal and copies it to the clipboard when possible.

.NOTES
    Requires: Git installed and available in PATH
#>

[CmdletBinding()]
param ()

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

        if ($result -is [System.Array]) {
            return ($result -join [Environment]::NewLine)
        }

        return [string]$result
    }
    catch {
        return $Fallback
    }
}

try {
    Write-Log 'Collecting repository context...'

    $branch = Get-GitValue -Arguments @('rev-parse', '--abbrev-ref', 'HEAD') -Fallback 'main'
    $root = Get-GitValue -Arguments @('rev-parse', '--show-toplevel') -Fallback (Get-Location).Path
    $status = Get-GitValue -Arguments @('status', '--short') -Fallback 'No local changes detected.'
    $today = Get-Date -Format 'yyyy-MM-dd'

    Write-Log 'Building Copilot prompt...'

    $promptTemplate = @'
You are working in a git repository and need to prepare a clean commit.

Run these steps in order:

1. Run `git add .`
2. Run `git diff --cached --name-status`
3. Run `git diff --cached`
4. Ascertain what changed in the codebase from the staged diff
5. Generate a conventional commit message that matches the staged changes

Repository context:
- Date: {0}
- Branch: {1}
- Repository root: {2}

Current git status before staging:
```text
{3}
```

Rules for the commit message:
- Use conventional commit format: `type(scope): short imperative subject line`
- Allowed types: feat, fix, docs, style, refactor, perf, test, chore, ci, build
- Use a short lowercase scope when one is obvious; omit the scope if it is not
- Keep the subject imperative, concise, and without a trailing period
- Add a body only if the subject alone is not enough

Return exactly this structure:

### STAGED CHANGES
- Brief bullets summarizing what changed

### COMMIT MESSAGE
<full commit message>

### GIT COMMANDS
```bash
git add .
git commit -m "<subject line>"
```
'@

    $prompt = $promptTemplate -f $today, $branch, $root, $status

    Write-Log 'Prompt ready. Copy everything between the lines below and paste into Copilot Chat.'
    Write-Host ''
    Write-Host ('=' * 60)
    Write-Host $prompt
    Write-Host ('=' * 60)
    Write-Host ''
    Write-Log 'Done.'

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
