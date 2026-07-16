# The 210 Project V4.2.1

Patch release for the new-location publishing issue.

## Fix included
- Fixes `invalid input syntax for type uuid: ""` when creating a brand new location.
- New locations now remove the empty `id` before inserting, allowing Supabase to auto-generate the UUID.
- Existing location editing still works.

## Deploy
Upload this source to GitHub and let Netlify rebuild.

Build command: `npm run build`
Publish directory: `dist`

No new SQL is required if you already ran the V4.2 SQL.
