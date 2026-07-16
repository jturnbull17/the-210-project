-- The 210 Project V4 schema
-- Run this in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.countries (
  id text primary key,
  name text not null,
  phase text not null check (phase in ('phase1','phase2')),
  code text,
  route_order int not null default 0,
  dates text,
  summary text,
  progress int default 0 check (progress >= 0 and progress <= 100),
  current_location text,
  highlights text[] default '{}',
  tone text default 'sage',
  days int default 0,
  photos int default 0,
  videos int default 0,
  notes int default 0,
  km int default 0,
  is_published boolean default true,
  updated_at timestamptz default now()
);

create table if not exists public.locations (
  id uuid primary key default gen_random_uuid(),
  country_id text not null references public.countries(id) on delete cascade,
  slug text not null,
  name text not null,
  date_text text,
  summary text,
  blog text,
  highlights text[] default '{}',
  tags text[] default '{}',
  hero_image text,
  sort_order int default 0,
  is_published boolean default true,
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  unique(country_id, slug)
);

create table if not exists public.site_settings (
  id text primary key default 'main',
  current_country_id text references public.countries(id),
  current_location_slug text,
  updated_at timestamptz default now()
);

alter table public.countries enable row level security;
alter table public.locations enable row level security;
alter table public.site_settings enable row level security;

-- Public visitors can read published content.
drop policy if exists "public read countries" on public.countries;
create policy "public read countries" on public.countries for select using (is_published = true);

drop policy if exists "public read locations" on public.locations;
create policy "public read locations" on public.locations for select using (is_published = true);

drop policy if exists "public read settings" on public.site_settings;
create policy "public read settings" on public.site_settings for select using (true);

-- Authenticated admin user can manage content.
drop policy if exists "authenticated manage countries" on public.countries;
create policy "authenticated manage countries" on public.countries for all to authenticated using (true) with check (true);

drop policy if exists "authenticated manage locations" on public.locations;
create policy "authenticated manage locations" on public.locations for all to authenticated using (true) with check (true);

drop policy if exists "authenticated manage settings" on public.site_settings;
create policy "authenticated manage settings" on public.site_settings for all to authenticated using (true) with check (true);

insert into public.countries (id,name,phase,code,route_order,dates,summary,progress,current_location,highlights,tone,days,photos,videos,notes,km)
values
('colombia','Colombia','phase1','CO',1,'Sep 2026','Colombia begins The 210 Project with colour, movement and arrival.',25,'Medellin',array['First solo travel rhythm','Coffee region','Caribbean coast'],'sage',21,420,82,21,1180),
('peru','Peru','phase1','PE',2,'Sep / Oct 2026','Peru is the endurance chapter. Altitude, history and trekking turn the journey into a test of rhythm, patience and resilience.',65,'Cusco',array['Machu Picchu sunrise','Cusco altitude lesson','Paracas coastline'],'copper',24,690,120,24,2040),
('argentina','Argentina','phase1','AR',3,'Oct / Nov 2026','Argentina blends city energy with wilderness: a chapter about scale, long journeys, food, culture and the symbolic edge of the continent.',30,'Buenos Aires',array['Buenos Aires evenings','Patagonia hikes','Ushuaia'],'terracotta',24,620,110,21,3600),
('brazil','Brazil','phase1','BR',4,'Nov / Dec 2026','Brazil closes the South America act with warmth, rhythm, coastline and reflection before the story turns towards Asia.',0,'Rio',array['Rio sunset','Island days','Iguacu Falls'],'ochre',24,760,140,22,3100),
('vietnam','Vietnam','phase2','VN',5,'Jan 2027','Vietnam opens the Asia act. Food, movement and sensory overload create a reset after South America.',0,'Hanoi',array['Street food','Lanterns','Coastline'],'brick',18,520,95,18,1450),
('south-korea','South Korea','phase2','KR',6,'Jan / Feb 2027','South Korea becomes a study in pace, structure, modern culture and the design of everyday movement.',0,'Seoul',array['Seoul city rhythm','Markets','Busan coastline'],'plum',14,390,65,14,820),
('japan','Japan','phase2','JP',7,'Feb 2027','Japan is the detail chapter: trains, temples, neon, quiet rituals and the discipline of noticing more.',0,'Tokyo',array['Tokyo nights','Kyoto temples','Train journeys'],'rose',21,680,130,21,1600),
('hong-kong','Hong Kong','phase2','HK',8,'Mar 2027','Hong Kong compresses energy into skyline, movement, ferries, viewpoints and height.',0,'Hong Kong Island',array['Skyline','Ferries','Viewpoints'],'wine',7,240,42,7,220),
('singapore','Singapore','phase2','SG',9,'Mar 2027','Singapore closes the Asia act with design, systems, order, food and the feeling of a city built with intention.',0,'Marina Bay',array['Gardens','Hawker centres','Design'],'teal',7,260,38,7,180)
on conflict (id) do update set summary=excluded.summary;

insert into public.locations (country_id, slug, name, date_text, summary, blog, highlights, tags, hero_image, sort_order)
values
('peru','lima','Lima','Sep 2026','The coastal entry point into Peru and the first step into a slower rhythm.','Lima starts as a transition point. The city gives the project a softer landing before the landscape becomes more demanding.',array['First Peruvian meal','Coastal walk','Planning the onward route'],array['food','coast','arrival'],'https://images.unsplash.com/photo-1531968455001-5c5272a41129?auto=format&fit=crop&w=1200&q=80',1),
('peru','cusco','Cusco','Oct 2026','Altitude, history and a slower pace before Machu Picchu.','Cusco is where the journey becomes physical. The altitude makes everything slower, but that slowness becomes useful.',array['Altitude adjustment','Old town wandering','Preparing for Machu Picchu'],array['altitude','history','patience'],'https://images.unsplash.com/photo-1526392060635-9d6019884377?auto=format&fit=crop&w=1200&q=80',2),
('japan','tokyo','Tokyo','Feb 2027','Neon, trains and a city that rewards attention to detail.','Tokyo becomes a detail chapter. The city moves quickly, but the archive is about the small systems: signs, stations, food counters and late-night streets.',array['Night streets','Train systems','Food counters'],array['curiosity','city','detail'],'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?auto=format&fit=crop&w=1200&q=80',1),
('brazil','rio','Rio','Dec 2026','Colour, rhythm and the closing note of South America.','Rio closes the first act of The 210 Project. The archive here is less about motion and more about presence: sunset, music, water and reflection.',array['Sunset','Beach walks','Closing reflection'],array['joy','reflection','coast'],'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?auto=format&fit=crop&w=1200&q=80',1)
on conflict (country_id, slug) do nothing;

insert into public.site_settings (id,current_country_id,current_location_slug) values ('main','peru','cusco') on conflict (id) do update set current_country_id=excluded.current_country_id, current_location_slug=excluded.current_location_slug;
