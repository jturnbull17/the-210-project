create extension if not exists pgcrypto;
create table if not exists public.countries (id text primary key,name text not null,phase text not null check (phase in ('phase1','phase2')),code text,route_order int default 0,dates text,summary text,progress int default 0,current_location text,highlights text[] default '{}',tone text default 'sage',days int default 0,status text default 'upcoming',is_published boolean default true,updated_at timestamptz default now());
alter table public.countries add column if not exists status text default 'upcoming';
do $$ begin alter table public.countries add constraint countries_status_check check (status in ('upcoming','live','visited')); exception when duplicate_object then null; end $$;
create table if not exists public.locations (id uuid primary key default gen_random_uuid(),country_id text not null references public.countries(id) on delete cascade,slug text not null,name text not null,date_text text,summary text,blog text,highlights text[] default '{}',tags text[] default '{}',hero_image text,sort_order int default 0,is_published boolean default true,created_at timestamptz default now(),updated_at timestamptz default now(),unique(country_id,slug));
create table if not exists public.media (id uuid primary key default gen_random_uuid(),location_id uuid not null references public.locations(id) on delete cascade,url text not null,file_path text,caption text,media_type text default 'photo',sort_order int default 0,created_at timestamptz default now());
alter table public.media add column if not exists caption text;
alter table public.media add column if not exists media_type text default 'photo';
create table if not exists public.comments (id uuid primary key default gen_random_uuid(),location_id uuid not null references public.locations(id) on delete cascade,parent_id uuid references public.comments(id) on delete cascade,name text not null,comment text not null,created_at timestamptz default now());
create table if not exists public.site_settings (id text primary key default 'main',current_country_id text references public.countries(id),current_location_slug text,default_phase text default 'phase1',updated_at timestamptz default now());
alter table public.site_settings add column if not exists default_phase text default 'phase1';
do $$ begin alter table public.site_settings add constraint site_settings_default_phase_check check (default_phase in ('phase1','phase2')); exception when duplicate_object then null; end $$;
alter table public.countries enable row level security;alter table public.locations enable row level security;alter table public.media enable row level security;alter table public.comments enable row level security;alter table public.site_settings enable row level security;
drop policy if exists "public read countries" on public.countries;create policy "public read countries" on public.countries for select using (is_published=true);
drop policy if exists "public read locations" on public.locations;create policy "public read locations" on public.locations for select using (is_published=true);
drop policy if exists "public read media" on public.media;create policy "public read media" on public.media for select using (true);
drop policy if exists "public read comments" on public.comments;create policy "public read comments" on public.comments for select using (true);
drop policy if exists "public add comments" on public.comments;create policy "public add comments" on public.comments for insert with check (true);
drop policy if exists "public read settings" on public.site_settings;create policy "public read settings" on public.site_settings for select using (true);
drop policy if exists "authenticated manage countries" on public.countries;create policy "authenticated manage countries" on public.countries for all to authenticated using (true) with check (true);
drop policy if exists "authenticated manage locations" on public.locations;create policy "authenticated manage locations" on public.locations for all to authenticated using (true) with check (true);
drop policy if exists "authenticated manage media" on public.media;create policy "authenticated manage media" on public.media for all to authenticated using (true) with check (true);
drop policy if exists "authenticated manage comments" on public.comments;create policy "authenticated manage comments" on public.comments for all to authenticated using (true) with check (true);
drop policy if exists "authenticated manage settings" on public.site_settings;create policy "authenticated manage settings" on public.site_settings for all to authenticated using (true) with check (true);
insert into public.countries (id,name,phase,code,route_order,dates,summary,current_location,highlights,tone,days,status) values
('colombia','Colombia','phase1','CO',1,'Sep 2026','Colombia begins The 210 Project with colour, movement and arrival.','Medellin',array[]::text[],'sage',21,'upcoming'),
('peru','Peru','phase1','PE',2,'Sep / Oct 2026','Peru is the endurance chapter.','Cusco',array[]::text[],'copper',24,'live'),
('argentina','Argentina','phase1','AR',3,'Oct / Nov 2026','Argentina blends city energy with wilderness.','Buenos Aires',array[]::text[],'terracotta',24,'upcoming'),
('brazil','Brazil','phase1','BR',4,'Nov / Dec 2026','Brazil closes the South America act.','Rio',array[]::text[],'ochre',24,'upcoming'),
('vietnam','Vietnam','phase2','VN',5,'Jan 2027','Vietnam opens the Asia act.','Hanoi',array[]::text[],'brick',18,'upcoming'),
('south-korea','South Korea','phase2','KR',6,'Jan / Feb 2027','South Korea becomes a study in pace and structure.','Seoul',array[]::text[],'plum',14,'upcoming'),
('japan','Japan','phase2','JP',7,'Feb 2027','Japan is the detail chapter.','Tokyo',array[]::text[],'rose',21,'upcoming'),
('hong-kong','Hong Kong','phase2','HK',8,'Mar 2027','Hong Kong compresses energy into skyline and movement.','Hong Kong Island',array[]::text[],'wine',7,'upcoming'),
('singapore','Singapore','phase2','SG',9,'Mar 2027','Singapore closes the Asia act.','Marina Bay',array[]::text[],'teal',7,'upcoming') on conflict (id) do nothing;
insert into public.site_settings (id,current_country_id,current_location_slug,default_phase) values ('main','peru','cusco','phase1') on conflict (id) do update set current_country_id=excluded.current_country_id,current_location_slug=excluded.current_location_slug;
insert into storage.buckets (id,name,public) values ('trip-media','trip-media',true) on conflict (id) do update set public=true;
drop policy if exists "public read trip media" on storage.objects;create policy "public read trip media" on storage.objects for select using (bucket_id='trip-media');
drop policy if exists "authenticated upload trip media" on storage.objects;create policy "authenticated upload trip media" on storage.objects for insert to authenticated with check (bucket_id='trip-media');
drop policy if exists "authenticated update trip media" on storage.objects;create policy "authenticated update trip media" on storage.objects for update to authenticated using (bucket_id='trip-media') with check (bucket_id='trip-media');
drop policy if exists "authenticated delete trip media" on storage.objects;create policy "authenticated delete trip media" on storage.objects for delete to authenticated using (bucket_id='trip-media');
