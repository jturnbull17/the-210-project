# The 210 Project V4.6

Mobile-first refinements, video uploads and admin-controlled default map phase.

## Included
- Home intro updated to: Jack and Grace's live travel journal around South America and Asia.
- `Detailed Blog` renamed to `The Story`.
- Map country panel background changed from light/white to a darker sage-green that complements the main green palette.
- Removed tags from public blog posts and removed tags from the admin form.
- Bottom nav now only has `Map` and `AI`. Map scrolls to the map panel itself.
- Admin can set the default homepage map phase: Phase 1 or Phase 2.
- Upload supports images and videos.
- Blog embeds now support both image and video media using `[[media:MEDIA_ID]]`.
- Existing `[[photo:MEDIA_ID]]` tokens still work for backwards compatibility.
- Admin media rows include copy token button.
- Blog text is smaller on mobile and the public story background is softer/darker to reduce glare.
- Comments and threaded replies remain included.

## Deploy
- Upload source to GitHub.
- Netlify build command: `npm run build`.
- Netlify publish directory: `dist`.

## Supabase
Run `supabase/schema.sql` in a new SQL query. This adds `default_phase` to `site_settings` and keeps comments/media policies in place.
