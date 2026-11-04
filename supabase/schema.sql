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
  for select to authenticated using ((select auth.uid()) = user_id);

drop policy if exists "Insert own data" on public.startline_data;
create policy "Insert own data" on public.startline_data
  for insert to authenticated with check ((select auth.uid()) = user_id);

drop policy if exists "Update own data" on public.startline_data;
create policy "Update own data" on public.startline_data
  for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

-- Lets a signed-in person delete their own account from the app (required by the App Store).
-- Deleting the auth.users row also deletes their startline_data row through the foreign key above.
create or replace function public.delete_my_account()
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;
  delete from auth.users where id = auth.uid();
end;
$$;

revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;
