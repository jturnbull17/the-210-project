# The 210 Project V4.5

Mobile-first travel release.

## Included
- More mobile padding and smaller mobile type.
- Hero CTA changed to `ASK ABOUT THE JOURNEY` and links to the AI companion.
- Private Admin link moved to the footer only.
- Bottom mobile nav reduced to `Map` and `AI`, with correct anchors.
- Country map panel simplified to status, country and blog/location links only.
- Admin country summary field removed.
- Hero image URL field removed from location form.
- Per-photo captions when selecting multiple photos.
- Copy token button for uploaded photos.
- Blog comments with name/comment fields, threaded replies, and reply forms.
- Comments are stored in Supabase.

## Deploy
- Upload source to GitHub.
- Netlify build command: `npm run build`.
- Netlify publish directory: `dist`.

## Supabase
Run `supabase/schema.sql` in a new SQL query. This adds the comments table and policies.
