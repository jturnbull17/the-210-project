-- The 210 Project V4.8 recovery hotfix
-- Safe to run more than once. Restores countries phase/status support used by the frontend.

create table if not exists public.countries (
  id text primary key,
  name text not null,
  phase text default 'phase1',
  code text,
  status text default 'planned',
  summary text,
  updated_at timestamptz default now()
);

alter table public.countries add column if not exists phase text default 'phase1';
alter table public.countries add column if not exists code text;
alter table public.countries add column if not exists status text default 'planned';
alter table public.countries add column if not exists summary text;
alter table public.countries add column if not exists updated_at timestamptz default now();

insert into public.countries (id, name, phase, code, status)
values
  ('colombia','Colombia','phase1','CO','planned'),
  ('peru','Peru','phase1','PE','completed'),
  ('argentina','Argentina','phase1','AR','planned'),
  ('brazil','Brazil','phase1','BR','completed'),
  ('vietnam','Vietnam','phase2','VN','planned'),
  ('south-korea','South Korea','phase2','KR','planned'),
  ('japan','Japan','phase2','JP','completed'),
  ('hong-kong','Hong Kong','phase2','HK','planned'),
  ('singapore','Singapore','phase2','SG','planned')
on conflict (id) do update set
  name = excluded.name,
  phase = coalesce(public.countries.phase, excluded.phase),
  code = coalesce(public.countries.code, excluded.code),
  status = coalesce(public.countries.status, excluded.status),
  updated_at = now();

create table if not exists public.locations (
  id uuid primary key default gen_random_uuid(),
  country_id text references public.countries(id),
  title text,
  name text,
  body text,
  status text default 'draft',
  is_live boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.locations add column if not exists status text default 'draft';
alter table public.locations add column if not exists is_live boolean default false;
alter table public.locations add column if not exists updated_at timestamptz default now();

alter table public.countries enable row level security;
alter table public.locations enable row level security;

drop policy if exists "Public can read countries" on public.countries;
create policy "Public can read countries" on public.countries for select using (true);

drop policy if exists "Authenticated can manage countries" on public.countries;
create policy "Authenticated can manage countries" on public.countries for all to authenticated using (true) with check (true);

drop policy if exists "Public can read locations" on public.locations;
create policy "Public can read locations" on public.locations for select using (true);

drop policy if exists "Authenticated can manage locations" on public.locations;
create policy "Authenticated can manage locations" on public.locations for all to authenticated using (true) with check (true);
