# Draftspace

A calm, lightweight collaborative document workspace built with React, TypeScript, Vite, and Tiptap.

## Run locally

**Quick preview:** open `index.html` directly in a browser. This is a self-contained preview that supports document editing, browser-local saving, basic formatting, `.txt`/`.md` import, and simulated sharing. It does not require Node.js.

**Developer build:** Requirements: Node.js 20+ and npm. Run `npm install` and `npm run dev`, then open the local URL printed by Vite. The React/TypeScript app in `src/` is the developer implementation; use the Vite URL rather than opening `src/main.tsx` directly.

The standalone preview and developer implementation both use browser-local demo data. The app starts in **demo mode** and stores documents in this browser's `localStorage`, so it works without API keys or paid services. Use the account switcher at the bottom of the sidebar to inspect seeded users (`ritesh@example.com`, `maya@example.com`, `alex@example.com`). The seeded sample includes a document shared with Maya and a document shared with Ritesh.

## Features

- Create, rename, edit, delete, search, and reopen documents.
- Rich text: bold, italic, underline, H1/H2, bulleted lists, numbered lists.
- Automatic local persistence and a save indicator.
- Import `.txt` and `.md` files as editable documents. Files larger than 1 MB and unsupported types are rejected.
- Demo sharing supports viewer/editor roles, visible ownership, and a viewer-only editor state.
- Responsive dashboard and document editing layout.
- Unit tests for visibility and permission rules.

## Commands

```bash
npm run dev       # local development
npm run build     # TypeScript check + production build
npm run preview   # preview production build
npm test          # automated tests
```

## Deployment

The Vite frontend can be deployed to Vercel or Netlify with build command `npm run build` and output directory `dist`. No environment variables are required for the demo build.

**Important limitation:** the currently wired UI is a browser-local demo. Demo user switching and sharing are for reviewer walkthroughs, not real authentication or secure multi-user collaboration. Data does not synchronize between browsers/devices, and client-side demo permissions are not a security boundary. Do not use this mode for sensitive documents. `supabase/schema.sql` provides a starting Postgres/RLS schema for a hosted backend, but it is not wired into this UI yet. A production version must add Supabase Auth, server-enforced authorization, and integration tests before claiming real multi-user persistence.

## Architecture

- `src/App.tsx`: dashboard, editor, file import, demo sharing, and local persistence.
- `src/domain.ts`: small pure permission and document-visibility functions.
- `src/domain.test.ts`: automated tests for viewer/editor access behavior.
- `supabase/schema.sql`: proposed hosted schema and RLS policies (not currently used by the demo UI).

Document content is stored as Tiptap/ProseMirror JSON, which preserves formatting on save/reopen. The local adapter is intentionally dependency-free beyond the editor stack so reviewers can run it immediately. The main tradeoff is that local persistence is not a substitute for backend persistence; this limitation is explicit rather than hidden.
