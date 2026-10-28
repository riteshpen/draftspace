-- Draftspace hosted schema (Postgres / Supabase).
-- Apply in the Supabase SQL Editor. Authenticated users own their documents;
-- shares grant explicit viewer/editor access. RLS is the security boundary.
create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null default 'Untitled document' check (char_length(title) between 1 and 180),
  content jsonb not null default '{"type":"doc","content":[{"type":"paragraph"}]}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.document_shares (
  document_id uuid not null references public.documents(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  permission text not null check (permission in ('viewer','editor')),
  created_at timestamptz not null default now(),
  primary key (document_id,user_id)
);
create index if not exists documents_owner_updated_idx on public.documents(owner_id, updated_at desc);
create index if not exists document_shares_user_idx on public.document_shares(user_id);
alter table public.documents enable row level security;
alter table public.document_shares enable row level security;
create policy "owners and shared users can read documents" on public.documents for select to authenticated
using (owner_id = auth.uid() or exists (select 1 from public.document_shares s where s.document_id = id and s.user_id = auth.uid()));
create policy "owners can create documents" on public.documents for insert to authenticated with check (owner_id = auth.uid());
create policy "owners and editors can update documents" on public.documents for update to authenticated
using (owner_id = auth.uid() or exists (select 1 from public.document_shares s where s.document_id = id and s.user_id = auth.uid() and s.permission = 'editor'))
with check (owner_id = auth.uid() or exists (select 1 from public.document_shares s where s.document_id = id and s.user_id = auth.uid() and s.permission = 'editor'));
create policy "owners can delete documents" on public.documents for delete to authenticated using (owner_id = auth.uid());
create policy "owners and recipients can read shares" on public.document_shares for select to authenticated
using (user_id = auth.uid() or exists (select 1 from public.documents d where d.id = document_id and d.owner_id = auth.uid()));
create policy "owners can grant access" on public.document_shares for insert to authenticated
with check (exists (select 1 from public.documents d where d.id = document_id and d.owner_id = auth.uid()));
create policy "owners can update access" on public.document_shares for update to authenticated
using (exists (select 1 from public.documents d where d.id = document_id and d.owner_id = auth.uid()))
with check (exists (select 1 from public.documents d where d.id = document_id and d.owner_id = auth.uid()));
create policy "owners can revoke access" on public.document_shares for delete to authenticated
using (exists (select 1 from public.documents d where d.id = document_id and d.owner_id = auth.uid()));
