# The 210 Project V4.2

This version keeps the V4.1 baseline and adds the requested functional improvements:

- Archive now shows all countries.
- Non-live countries are greyed out.
- The live country appears yellow.
- Archive country cards link to country pages.
- The map has more recognisable South America and Asia outline shapes.
- Selected map marker changes to a darker hue.
- Admin save/publish buttons show clearer loading/saved states.
- Admin can edit existing location pages after publishing.
- Admin can upload photos from a phone via Supabase Storage.
- Location pages show a gallery preview and link to all photos.
- Gallery pages are available at `/archive/<country>/<location>/gallery`.
- Breadcrumb navigation added across country, place and gallery pages.

## Deploy
Use GitHub + Netlify:

- Build command: `npm run build`
- Publish directory: `dist`

## Supabase
Run `supabase/schema.sql` in Supabase SQL Editor. This updates the V4 schema with media support and storage policies.

## Environment variables
Add these in Netlify:

- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`
