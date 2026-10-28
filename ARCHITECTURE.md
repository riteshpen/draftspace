# Architecture and tradeoffs

## Product slice

Draftspace focuses on the core document loop: create → write/format → persist → reopen, plus import and a small sharing walkthrough. The UI uses a document dashboard and a distraction-light paper editor.

## Implementation

- **React + TypeScript + Vite** keep iteration fast while providing typed component boundaries.
- **Tiptap / ProseMirror JSON** handle editing and preserve document structure across refreshes.
- **Browser localStorage** makes the demo immediately runnable without credentials or external dependencies. A single storage key holds document records, including owner, shares, content, and update timestamps.
- **Pure access helpers** (`canView`, `canEdit`, `visibleDocs`) isolate the demo's permission decisions and make them testable.
- **Supabase schema draft** shows the intended hosted persistence model: documents, explicit document shares, foreign keys, indexes, and row-level security policies.

## Scope decisions

1. Imported files are limited to `.txt` and `.md`; unsupported types and files over 1 MB are rejected. Markdown headings and simple bullet lists are converted to editable blocks.
2. Accounts are seeded demo identities to make sharing flows easy to inspect without a signup process.
3. Real-time collaboration, comments, version history, DOCX parsing, and exports were excluded to protect the core editing flow.
4. The present UI is explicitly a local demo, not a secure multi-user application. The supplied RLS schema is a foundation only and needs to be connected and tested before production use.

## Next engineering steps

- Wire Supabase Auth and replace localStorage reads/writes with authenticated database operations.
- Resolve invite emails to verified auth users, then insert/update `document_shares` only through owner-authorized operations.
- Add integration tests for RLS: owner can share, viewer cannot update, editor can update, unrelated users cannot read.
- Add save debouncing, conflict handling, and unsaved-change recovery.
- Add import parsing tests and accessible keyboard shortcuts.
