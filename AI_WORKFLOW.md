# AI workflow note

## Tools

ChatGPT was used as an engineering assistant to help plan a deliberately scoped product slice, scaffold implementation files, draft documentation, and identify test cases.

## Where AI helped

- Turning the assignment into a prioritized feature list and timebox.
- Drafting the React/Tiptap component structure, responsive styling, and a starter Postgres/RLS schema.
- Suggesting permission-focused unit tests and a reviewer-oriented README.

## Judgment and limitations

The implementation deliberately labels its current persistence/sharing path as a local demo. The seeded account switcher is not authentication, localStorage is not cross-device persistence, and frontend permission checks are not a security boundary. The SQL schema is a starting point and is not wired into the current interface. Those limitations should not be described to reviewers as production-ready backend behavior.

## Verification checklist

Before submission, run `npm test` and `npm run build`; manually create a document, format text, refresh, reopen it, import a `.txt`/`.md` file, and exercise the seeded share/viewer flow. Inspect the deployed URL in a private browser window and confirm the README matches the actual behavior. Update this note with the actual results and any code suggestions that were rejected or changed during implementation; do not claim a check passed until it has been run.
