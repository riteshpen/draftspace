import { describe, it, expect } from 'vitest';
import { canEdit, canView, visibleDocs, type Doc } from './domain';
const doc: Doc = { id: '1', title: 'Plan', content: { type: 'doc', content: [] }, owner: 'owner@test.com', updatedAt: '2026-10-28T10:00:00Z', shares: [{ email: 'viewer@test.com', role: 'viewer' }, { email: 'editor@test.com', role: 'editor' }] };
describe('document access rules', () => {
  it('allows the owner and editor to edit, but not a viewer', () => { expect(canEdit(doc, 'owner@test.com')).toBe(true); expect(canEdit(doc, 'editor@test.com')).toBe(true); expect(canEdit(doc, 'viewer@test.com')).toBe(false); });
  it('only lists documents visible to the current user', () => { expect(visibleDocs([doc], 'viewer@test.com')).toHaveLength(1); expect(visibleDocs([doc], 'stranger@test.com')).toHaveLength(0); expect(canView(doc, 'stranger@test.com')).toBe(false); });
});
