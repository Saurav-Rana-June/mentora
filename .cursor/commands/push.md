# /push

You are an expert Git assistant.

When the `/push` command is executed, automatically analyze all staged and unstaged changes in the repository and perform the complete Git push workflow.

## Responsibilities

1. Inspect all modified, added, deleted, renamed, and moved files.
2. Understand the actual purpose of the changes.
3. Generate a concise, professional commit message based on the detected changes.
4. Stage all changes.
5. Commit the changes.
6. Detect the current Git branch automatically.
7. Push to the current branch.

---

## Commit Message Rules

Use the following prefixes only:

### fixes
Use for bug fixes, issue resolutions, refactoring to solve problems, UI corrections, crash fixes, validation fixes, etc.

Example:
```bash
fixes: Fixed Home Screen navigation issue.
fixes: Resolved banner loading problem.
fixes: Corrected login validation errors.
```

### updates
Use for enhancements, improvements, UI changes, optimizations, code improvements, content updates, configuration changes, etc.

Example:
```bash
updates: Updated Home Screen banners.
updates: Improved coupon listing performance.
updates: Enhanced profile screen UI.
```

### tasks
Use for new features, new modules, new screens, new integrations, new APIs, new services, or newly created functionality.

Example:
```bash
tasks: Created a new login method.
tasks: Added Firebase authentication support.
tasks: Implemented coupon redemption flow.
```

### release
Use only when releasing a version.

Example:
```bash
release: Released version 2.3.52.
release: Released version 3.0.0.
```

---

## Commit Message Requirements

- Generate the message from the actual code changes.
- Keep it short and professional.
- Use sentence case.
- Maximum 80 characters when possible.
- Never use generic messages such as:
  - Update code
  - Fix bugs
  - Changes
  - Work in progress
  - Final update
  - Misc updates

Bad:
```bash
git commit -m "updates: Updated files."
```

Good:
```bash
git commit -m "updates: Updated Home Screen banners."
git commit -m "fixes: Fixed coupon expiration calculation."
git commit -m "tasks: Added Google Sign-In authentication."
```

---

## Execution Steps

Run:

```bash
git add .
```

Generate commit message after analyzing changes:

```bash
git commit -m "<generated_message>"
```

Get the current branch:

```bash
git branch --show-current
```

Push using the current branch:

```bash
git push origin <current_branch>
```

---

## Examples

### Example 1

Changes:
- Updated home banners
- Modified carousel timing

Output:

```bash
git add .
git commit -m "updates: Updated Home Screen banners."
git push origin sr-coupons
```

### Example 2

Changes:
- Fixed login validation
- Resolved authentication bug

Output:

```bash
git add .
git commit -m "fixes: Fixed login validation issue."
git push origin sr-coupons
```

### Example 3

Changes:
- Added OTP login

Output:

```bash
git add .
git commit -m "tasks: Added OTP login authentication."
git push origin sr-coupons
```

### Example 4

Changes:
- Version upgraded to 2.3.52

Output:

```bash
git add .
git commit -m "release: Released version 2.3.52."
git push origin sr-coupons
```

---

## Important

Before committing:

1. Review all changed files.
2. Infer the primary purpose of the changes.
3. Generate the most accurate commit message possible.
4. If multiple unrelated changes exist, summarize the dominant change.
5. Always push to the currently checked-out branch.
6. Never ask for a commit message unless the intent of the changes cannot be determined.