# The 210 Project V4.4

Travel-first rich story editor release.

## Included
- Admin notifications now auto-dismiss.
- Save country summary/status now uses a direct update instead of upsert.
- Country status labels are now: COMING SOON, LIVE NOW, COMPLETED.
- Improved Asia map outline.
- Removed Curated Top Moments, Highlights and Photo Preview sections from public pages.
- Added photo captions when uploading photos.
- Added photo caption editing for existing photos.
- Added rich blog embedding: use `[[photo:PHOTO_ID]]` inside the blog body to place photos where you want them.
- Admin photo rows show each photo's embed token.
- Location pages render text and embedded photos inline.
- Gallery pages remain available.

## Deploy
- Upload source to GitHub.
- Netlify build command: `npm run build`.
- Netlify publish directory: `dist`.

## Supabase
Run `supabase/schema.sql` as a new SQL query. This is safe to run over V4.3 and adds/keeps the fields V4.4 uses.
