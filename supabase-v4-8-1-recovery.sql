-- The 210 Project V4.8.1 recovery hotfix
-- Safe to run more than once. Uses existing country statuses: upcoming, live, visited.

alter table public.countries add column if not exists phase text default 'phase1';
alter table public.countries add column if not exists code text;
alter table public.countries add column if not exists route_order integer default 0;
alter table public.countries add column if not exists summary text;
alter table public.countries add column if not exists is_published boolean default true;
alter table public.countries add column if not exists updated_at timestamptz default now();
alter table public.countries add column if not exists status text default 'upcoming';

update public.countries
set status = case
  when status = 'planned' then 'upcoming'
  when status = 'active' then 'live'
  when status = 'completed' then 'visited'
  else status
end;

insert into public.countries (id, name, phase, code, route_order, status, is_published)
values
  ('colombia','Colombia','phase1','CO',1,'live',true),
  ('peru','Peru','phase1','PE',2,'visited',true),
  ('argentina','Argentina','phase1','AR',3,'visited',true),
  ('brazil','Brazil','phase1','BR',4,'visited',true),
  ('vietnam','Vietnam','phase2','VN',5,'visited',true),
  ('south-korea','South Korea','phase2','KR',6,'upcoming',true),
  ('japan','Japan','phase2','JP',7,'upcoming',true),
  ('hong-kong','Hong Kong','phase2','HK',8,'upcoming',true),
  ('singapore','Singapore','phase2','SG',9,'upcoming',true)
on conflict (id) do update set
  name = excluded.name,
  phase = excluded.phase,
  code = excluded.code,
  route_order = excluded.route_order,
  status = excluded.status,
  is_published = excluded.is_published,
  updated_at = now();

alter table public.countries enable row level security;

drop policy if exists "Public can read countries" on public.countries;
create policy "Public can read countries" on public.countries for select using (true);

drop policy if exists "Authenticated can manage countries" on public.countries;
create policy "Authenticated can manage countries" on public.countries for all to authenticated using (true) with check (true);

alter table public.locations add column if not exists is_live boolean default false;
alter table public.locations enable row level security;

drop policy if exists "Public can read locations" on public.locations;
create policy "Public can read locations" on public.locations for select using (true);

drop policy if exists "Authenticated can manage locations" on public.locations;
create policy "Authenticated can manage locations" on public.locations for all to authenticated using (true) with check (true);
