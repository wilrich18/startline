-- Start/Line: one row of saved app data per signed-in person.
-- Run this once in your Supabase project: Dashboard > SQL Editor > New query > paste > Run.

create table if not exists public.startline_data (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Row-level security: each person can only read and write their own row.
alter table public.startline_data enable row level security;

drop policy if exists "Read own data" on public.startline_data;
create policy "Read own data" on public.startline_data
  for select to authenticated using (auth.uid() = user_id);

drop policy if exists "Insert own data" on public.startline_data;
create policy "Insert own data" on public.startline_data
  for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists "Update own data" on public.startline_data;
create policy "Update own data" on public.startline_data
  for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);
