# Gemini Tickets Skill (`tickets`)

An autonomous ticket-based development school and workflow skill for Google Antigravity / Gemini CLI.

This skill trains and guides the AI agent to operate as a disciplined software engineer working through a backlog of Markdown tickets located in a `tickets/` directory at the repository root.

---

## Workflow Overview

```mermaid
flowchart TD
    A[Discover Tickets in tickets/] --> B[Pick Lowest Pending Ticket: {nnnn}-{name_slug}.md]
    B --> C[Read Ticket & Clarify at first ---]
    C -->|Questions Exist| D[Ask in Console & Log to Ticket]
    C -->|Clear| E[Log Clear Status]
    D --> F[Create Branch: git checkout -b {nnnn}-{name_slug}]
    E --> F
    F --> G[Implement Code & Run Tests]
    G --> H[Append Completion Summary at second ---]
    H --> I[Rename Ticket to {nnnn}-{name_slug}.complete.md]
    I --> J[git commit & git push origin {nnnn}-{name_slug}]
```

---

## File Naming Conventions

### Active Tickets
Format: `tickets/{nnnn}-{name_slug}.md`
- **`{nnnn}`**: 4-digit zero-padded ticket number (`0001`, `0002`, `0015`).
- **`{name_slug}`**: Concise task description containing only lowercase alphanumerics and hyphens (`[a-z0-9-]+`).

*Examples:*
- `tickets/0001-setup-database-schema.md`
- `tickets/0002-add-user-authentication.md`

### Completed Tickets
Format: `tickets/{nnnn}-{name_slug}.complete.md`
- When a ticket is completed and verified, it is renamed to `.complete.md`.
- Any file ending in `.complete.md` is automatically skipped by the agent.

---

## Ticket Markdown Structure

Each ticket markdown file contains three sequential sections separated by `---` tokens:

```markdown
# [Ticket Title]

## Summary
Brief description of the feature or bug fix.

## Requirements
- Concrete requirement 1
- Concrete requirement 2

## Verification & Acceptance Criteria
- [ ] Unit tests passing
- [ ] Manual verification steps

---
### Clarification Log
- **Agent:** Question regarding edge case or requirement?
- **User:** Clarification response provided in console.
<!-- If requirements are already clear: -->
- *Requirements are complete and clear; no clarifying questions needed.*

---
### Completion Summary
- **Ticket:** {nnnn}-{name_slug}
- **Branch:** {nnnn}-{name_slug}
- **Summary of Changes:**
  - Implemented XYZ in module A
  - Refactored ABC in module B
- **Files Modified / Added:**
  - `path/to/file1.go`
  - `path/to/file2.go`
- **Verification Results:**
  - Automated tests passing: `go test ./...`
```

---

## Installation

### Option 1: Global Installation (Recommended)
Available across all projects on your machine:

```bash
# Clone or copy into your global Gemini config:
git clone https://github.com/SamSoupSauce/gemini-tickets-skill.git ~/.gemini/config/skills/tickets
```

Or on Windows PowerShell:
```powershell
git clone https://github.com/SamSoupSauce/gemini-tickets-skill.git "$HOME\.gemini\config\skills\tickets"
```

### Option 2: Project-Specific Workspace Skill
Version-controlled within a specific project:

```bash
mkdir -p .agents/skills/tickets
cp -r /path/to/gemini-tickets-skill/* .agents/skills/tickets/
```

---

## Helper Utilities

The skill includes helper scripts to list, validate, and inspect tickets in `tickets/`:

- **Python**: `python scripts/list_tickets.py`
- **PowerShell**: `pwsh scripts/list_tickets.ps1`

Run with `--init` / `-Init` to automatically initialize an empty `tickets/` directory in the current repository.

---

## License

MIT License. See [LICENSE](./LICENSE) for details.
