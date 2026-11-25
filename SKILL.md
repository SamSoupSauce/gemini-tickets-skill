---
name: tickets
description: >-
  Autonomous ticket-based development school and workflow. Use this skill when
  working on repository tasks structured as markdown tickets in the `tickets/`
  directory with the naming convention `{nnnn}-{name_slug}.md`, managing clarification
  logs, creating feature branches, completing tasks, renaming to `.complete.md`,
  and committing and pushing to GitHub.
---

# Ticketing School Workflow (`tickets`)

This skill governs the autonomous ticket-driven development lifecycle ("school") where work is structured as individual Markdown tickets in the `tickets/` directory at the repository root.

---

## Ticket File Naming Rules

- **Active / Pending Tickets**: `tickets/{nnnn}-{name_slug}.md`
  - `{nnnn}`: 4-digit zero-padded number (e.g., `0001`, `0002`).
  - `{name_slug}`: Lowercase alphanumerics and hyphens only (`[a-z0-9-]+`).
- **Completed Tickets**: `tickets/{nnnn}-{name_slug}.complete.md`
  - Any file ending in `.complete.md` is already finished and must be skipped when looking for active work.

---

## Step-by-Step Procedure

### Step 1: Ticket Discovery & Selection
1. Look for the `tickets/` directory at the repository root.
2. If the user specified a specific ticket (e.g., "work on ticket 0001" or "0001-fix-login"), locate that file.
3. Otherwise, select the lowest-numbered pending ticket (`{nnnn}-{name_slug}.md`) that does not have `.complete.md` in its name.
4. You can run the helper script to inspect pending tickets:
   ```bash
   python ~/.gemini/config/skills/tickets/scripts/list_tickets.py
   ```

### Step 2: Read Ticket & Clarification Protocol
1. Read the ticket markdown content.
2. The ticket contains requirements followed by a `---` separator token.
3. Review the ticket specifications thoroughly.
4. **If you have clarifying questions**:
   - Output the questions directly to the user in the console/chat.
   - Wait for the user's answers.
   - Record the exchange below the `---` separator in the ticket file as a structured chat log:
     ```markdown
     ---
     ### Clarification Log
     - **Agent:** [Question asked to console]
     - **User:** [Response from user]
     ```
5. **If requirements are already clear**:
   - Inform the user in the console that requirements are clear and work is ready to begin.
   - Log below the `---` token in the ticket file:
     ```markdown
     ---
     ### Clarification Log
     - *Requirements are complete and clear; no clarifying questions needed.*
     ```

### Step 3: Git Branch Creation
When ready to begin implementation:
1. Ensure the working tree is clean.
2. Create and switch to a new git branch titled `{nnnn}-{name_slug}`:
   ```bash
   git checkout -b {nnnn}-{name_slug}
   ```

### Step 4: Perform Changes & Verify
1. Make all source code, asset, configuration, and documentation changes required by the ticket.
2. Write unit and integration tests covering the new behavior or bug fix.
3. Run the project's test suite and build commands to verify that all tests pass and there are no regressions.

### Step 5: Complete & Rename Ticket
1. Re-open the ticket file.
2. Append a second `---` separator token followed by the comprehensive completion description (the same description output to the console):
   ```markdown
   ---
   ### Completion Summary
   - **Ticket:** {nnnn}-{name_slug}
   - **Branch:** {nnnn}-{name_slug}
   - **Summary of Changes:**
     - [Detailed bullet points of changes made]
   - **Files Modified / Added:**
     - [Clickable file links]
   - **Verification Results:**
     - [Test commands and results]
   ```
3. Rename the ticket file from `tickets/{nnnn}-{name_slug}.md` to `tickets/{nnnn}-{name_slug}.complete.md`:
   ```bash
   git mv tickets/{nnnn}-{name_slug}.md tickets/{nnnn}-{name_slug}.complete.md
   ```

### Step 6: Git Commit & Push to GitHub
1. Stage all changes including the renamed ticket:
   ```bash
   git add -A
   ```
2. Commit with a clear commit message referencing the ticket:
   ```bash
   git commit -m "Complete ticket {nnnn}: {name_slug}"
   ```
3. Push the feature branch to GitHub:
   ```bash
   git push -u origin {nnnn}-{name_slug}
   ```
4. Output the completion summary to the user console with clickable links to modified files, the completed ticket, and the pushed branch.

---

## Detailed References & Templates
- [Ticket Lifecycle Guide](file:///C:/Users/samue/.gemini/config/skills/tickets/references/lifecycle.md)
- [Ticket Template](file:///C:/Users/samue/.gemini/config/skills/tickets/resources/ticket_template.md)
