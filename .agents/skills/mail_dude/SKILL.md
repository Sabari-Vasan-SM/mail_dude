```markdown
# mail_dude Development Patterns

> Auto-generated skill from repository analysis

## Overview
This skill teaches you the core development patterns and conventions used in the `mail_dude` Swift codebase. You'll learn how to structure files, write imports and exports, and follow the project's unique coding and commit styles. This guide also covers how to write and organize tests, and provides suggested commands for common workflows.

## Coding Conventions

### File Naming
- Use **snake_case** for all file names.
  - Example: `mail_sender.swift`, `email_parser.swift`

### Import Style
- Use **relative imports**.
  - Example:
    ```swift
    import ../utils/email_utils
    ```

### Export Style
- Use **named exports** to explicitly specify what is exported from a file.
  - Example:
    ```swift
    public struct MailSender { ... }
    ```

### Commit Messages
- Commit messages are **freeform** (no strict prefix), with an average length of 19 characters.
  - Example:  
    ```
    fix email parsing bug
    ```

## Workflows

### Adding a New Feature
**Trigger:** When you need to implement a new feature in the codebase  
**Command:** `/add-feature`

1. Create a new Swift file using snake_case naming.
2. Write your feature code, using relative imports for dependencies.
3. Use named exports for any public structs, classes, or functions.
4. Write or update corresponding test files (`*.test.*`).
5. Commit your changes with a concise, descriptive message.

### Fixing a Bug
**Trigger:** When you need to resolve a bug  
**Command:** `/fix-bug`

1. Locate the relevant code file(s).
2. Apply your fix, following import/export conventions.
3. Update or add test cases in the appropriate `*.test.*` file.
4. Commit your changes with a brief message describing the fix.

### Writing Tests
**Trigger:** When adding or updating tests  
**Command:** `/write-test`

1. Create or update a test file matching the `*.test.*` pattern (e.g., `mail_sender.test.swift`).
2. Write your test cases using the project's preferred testing approach.
3. Run tests to ensure correctness.

## Testing Patterns

- Test files follow the pattern: `*.test.*` (e.g., `email_parser.test.swift`).
- The specific testing framework is **unknown**; follow existing patterns in the repository.
- Place tests alongside or near the code they test, using the same snake_case naming convention.

## Commands
| Command       | Purpose                                 |
|---------------|-----------------------------------------|
| /add-feature  | Start workflow for adding a new feature |
| /fix-bug      | Start workflow for fixing a bug         |
| /write-test   | Start workflow for writing tests        |
```
