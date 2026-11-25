# Ticket Lifecycle & Specifications

This reference documents the detailed lifecycle, file naming conventions, parsing rules, and git procedures for the `tickets` school workflow.

---

## 1. Directory Structure

All tickets reside in the `tickets/` directory at the repository root:

```text
<repository_root>/
├── tickets/
│   ├── 0001-setup-database.complete.md
│   ├── 0002-add-user-auth.complete.md
│   ├── 0003-implement-payment-gateway.md     <-- Active / Pending
│   └── 0004-optimize-queries.md              <-- Next in queue
```

---

## 2. File Naming Rules

### Active Tickets
Format: `{nnnn}-{name_slug}.md`
- **`{nnnn}`**: Exactly 4 digits, zero-padded (e.g., `0001`, `0042`, `0100`).
- **`{name_slug}`**: Concise task slug containing **only** lowercase alphanumerics and hyphens (`[a-z0-9-]+`). No spaces, underscores, or special characters.
- **`.md`**: Standard Markdown extension.

Examples:
- `0001-init-physics-engine.md`
- `0015-fix-player-stair-climbing.md`

### Completed Tickets
Format: `{nnnn}-{name_slug}.complete.md`
- When a ticket's work is verified, the file is renamed by inserting `.complete` before `.md`.
- Active ticket scans must ignore any file matching `*.complete.md`.

---

## 3. Ticket Markdown Format

A ticket markdown file contains three sequential sections separated by `---` tokens:

```markdown
# [Ticket Title]

## Summary
Clear description of what needs to be accomplished.

## Requirements
- Concrete specifications
- Expected behavior

---
### Clarification Log
- **Agent:** Question regarding edge case or requirement?
- **User:** Clarification response provided in console.
<!-- If no questions were needed: -->
- *No clarifying questions required. Requirements are complete and unambiguous.*

---
### Completion Summary
- **Ticket:** {nnnn}-{name_slug}
- **Branch:** {nnnn}-{name_slug}
- **Commit:** <commit_hash>
- **Summary of Changes:**
  - Implemented XYZ in module A
  - Refactored ABC in module B
- **Verification:**
  - Automated tests passing: `go test ./...`
  - Manual verification completed.
```

---

## 4. Git Branching & Remote Workflow

1. **Feature Branch Creation**:
   - Ensure working tree is clean on the primary base branch (`main` or `master`).
   - Create and switch to the ticket branch:
     ```bash
     git checkout -b {nnnn}-{name_slug}
     ```

2. **Work & Local Verification**:
   - Make all source changes required by the ticket.
   - Run relevant test suites and compilation builds.

3. **Ticket Update & Rename**:
   - Append the second `---` and completion summary.
   - Rename ticket:
     ```bash
     git mv tickets/{nnnn}-{name_slug}.md tickets/{nnnn}-{name_slug}.complete.md
     ```

4. **Commit & Push**:
   - Stage all changes including the completed ticket:
     ```bash
     git add -A
     git commit -m "Complete ticket {nnnn}: {name_slug}"
     git push -u origin {nnnn}-{name_slug}
     ```
   - Verify that the push succeeded and the new branch is live on GitHub.
