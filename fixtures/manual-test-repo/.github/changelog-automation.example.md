# Changelog Automation Policy

protectedBranches:
  - main

pullRequestsRequired: true
allowDirectPushesToProtectedBranches: false

validationCommands:
  - npm test
  - npm run lint

versionBumpRules:
  patch:
    - documentation updates
    - bug fixes
  minor:
    - new fixture scenarios
    - new validation commands
  major:
    - breaking fixture behavior
