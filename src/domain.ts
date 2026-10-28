export type Role = 'viewer' | 'editor';
export type Share = { email: string; role: Role };
export type Doc = { id: string; title: string; content: any; owner: string; updatedAt: string; shares: Share[] };
export const DEMO_USERS = [
  { email: 'ritesh@example.com', name: 'Ritesh Penumatsa', initials: 'RP' },
  { email: 'maya@example.com', name: 'Maya Chen', initials: 'MC' },
  { email: 'alex@example.com', name: 'Alex Rivera', initials: 'AR' },
];
export const EMPTY_CONTENT = { type: 'doc', content: [{ type: 'paragraph' }] };
export function canEdit(doc: Doc, email: string) { return doc.owner === email || doc.shares.some(s => s.email === email && s.role === 'editor'); }
export function canView(doc: Doc, email: string) { return doc.owner === email || doc.shares.some(s => s.email === email); }
export function visibleDocs(docs: Doc[], email: string) { return docs.filter(d => canView(d, email)); }
