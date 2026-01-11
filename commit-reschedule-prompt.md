# Commit Reschedule Checker

You are checking all state schooldata packages for commits made during working hours that need to be rescheduled.

## Working Hours Definition

**Working hours:** Monday-Friday, 8am-5pm (08:00-17:00)

**Any commit made during these hours needs to be rescheduled to off-hours.**

## Your Task

1. Scan all packages in `/Users/almartin/Documents/state-schooldata/*schooldata`
2. For each package, check recent commits for timestamps during working hours
3. If found, note the package and commit details
4. Report summary of packages with working-hours commits

## What to Check

For each package:
```bash
cd /Users/almartin/Documents/state-schooldata/{package}
git log --since="1 day ago" --pretty=format:"%h %ai %s" --date=local
```

## Working Hours Check

Extract the hour from the commit timestamp:
- Format: `2026-01-08 14:30:15 -0500`
- Hour: `14` (2pm) → IN WORKING HOURS → needs rescheduling
- Hour: `19` (7pm) → NOT in working hours → OK

## Skip These

- Packages with unstaged changes (may have active work in progress)
- Packages on feature branches (intentional commits during dev)
- Weekend commits (even during daytime)

## Output Format

```
[timestamp] === Checking for working hours commits ===
[timestamp] Skipping {package} - has unstaged changes
[timestamp] 🕐 Checking {package} for working hours commits...
[timestamp] ✅ No working-hours commits found
[timestamp] ⚠️ Found working-hours commits:
  - {commit_hash} {timestamp} "{commit_message}"
  - {commit_hash} {timestamp} "{commit_message}"
[timestamp] === Commit reschedule check complete ===
```

## Important

- **DO NOT make any changes** - this is a SCAN ONLY
- Just report what you find
- If packages have unstaged changes, skip them (may be active work)
