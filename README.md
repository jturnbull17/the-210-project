# The 210 Project V4.1

This version makes the requested refinements before progressing further:

- Removes progress bars/countdown-style progress indicators
- Restores the previous Field Archive visual style: cream background, big editorial title, filter buttons, dark green media cards
- Keeps country and location pages functional through Supabase-backed routes
- Keeps admin support for live location, country summary and location page creation

## Netlify settings
Build command: `npm run build`
Publish directory: `dist`

## Supabase
Use the included `supabase/schema.sql` from the V4 starter. The database still supports progress, but the public UI no longer displays progress bars.
