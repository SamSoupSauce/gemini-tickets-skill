# 0001 - Fix README

## Summary
The Mermaid `flowchart TD` diagram under **Workflow Overview** in `README.md` fails to render on GitHub (`Unable to render rich display`) with a Mermaid syntax parse error on line 2 (`got 'DIAMOND_START'`). Unquoted square-bracket node labels containing `{nnnn}-{name_slug}` cause Mermaid to misinterpret `{` as the start of a diamond shape.

Reference screenshot: ![Workflow Overview Mermaid Parse Error](./Screenshot%202026-11-25%20132404.png)

### Observed Error
```text
Parse error on line 2:
...est Pending Ticket: {nnnn}-{name_slug}.m
----------------------^
Expecting 'SQE', 'DOUBLECIRCLEEND', 'PE', '-)', 'STADIUMEND', 'SUBROUTINEEND', 'PIPE', 'CYLINDEREND', 'DIAMOND_STOP', 'TAGEND', 'TRAPEND', 'INVTRAPEND', 'UNICODE_TEXT', 'TEXT', 'TAGSTART', got 'DIAMOND_START'
```

## Requirements
- Fix the Mermaid `flowchart TD` syntax in `README.md` (under `## Workflow Overview`) so it parses and renders cleanly on GitHub without errors.
- Quote node labels (`A["..."]`) or otherwise escape/format special characters (`{`, `}`, `:`, `/`, `---`) across all nodes (`A` through `J`) so no parse errors occur.
- Verify there are no other broken Mermaid blocks or markdown formatting errors in `README.md`.

## Verification & Acceptance Criteria
- [x] All nodes in the `README.md` `Workflow Overview` Mermaid diagram use valid Mermaid syntax (no unquoted `{...}` or special characters inside `[...]`).
- [x] Diagram syntax is validated locally (e.g., via Mermaid parser/CLI if available, or syntax inspection against Mermaid flowchart rules).
- [x] Existing `README.md` content outside the diagram fix remains intact.

---
### Clarification Log
- **Agent:**
  1. Should I preserve the exact node label text (including `{nnnn}-{name_slug}` and `---`) by wrapping labels in double quotes (`["..."]`), or simplify/reword any labels?
  2. Should `tickets/Screenshot 2026-11-25 132404.png` remain in `tickets/` and be committed alongside the completed ticket, or be removed before committing?
  3. Once answered, should I proceed with implementing the ticket on branch `0001-fix-readme` (updating the Clarification Log, fixing `README.md`, completing/renaming the ticket, and committing/pushing)?
- **User:** Do it all.

---
### Completion Summary
- **Ticket:** 0001-fix-readme
- **Branch:** 0001-fix-readme
- **Summary of Changes:**
  - Wrapped all Mermaid `flowchart TD` node labels (`A` through `J`) under `## Workflow Overview` in `README.md` with double quotes (`["..."]`) so `{nnnn}-{name_slug}`, `---`, `/`, and `:` parse as literal text instead of Mermaid shape/syntax tokens (fixing the `DIAMOND_START` parse error on GitHub).
  - Documented the ticket from `tickets/Screenshot 2026-11-25 132404.png` and recorded the clarification exchange.
- **Files Modified / Added:**
  - `README.md`
  - `tickets/0001-fix-readme.complete.md`
  - `tickets/Screenshot 2026-11-25 132404.png`
- **Verification Results:**
  - Inspected `git diff README.md` to confirm only lines 11–23 changed and all node labels (`A`–`J`) are double-quoted without unescaped quotes.
  - Confirmed via `Select-String` across `*.md`, `references/*.md`, and `resources/*.md` that `README.md:11` is the only Mermaid block in the repository.
  - Ran `powershell -ExecutionPolicy Bypass -File scripts/list_tickets.ps1` (exit code `0`) confirming ticket parsing and completion status.
