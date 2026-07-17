# The 210 Project V4.3

Map-led archive and travel CMS upgrade.

## Included
- Removed the large Field Archive country grid from the homepage.
- Country access now happens directly from the map selection panel.
- Map selected marker is dark; live marker is yellow; visited/done marker is green with a tick.
- Countries can be set as `upcoming`, `live`, or `visited` in admin.
- Admin can delete a location with a browser confirmation prompt.
- Admin can edit existing locations.
- Admin can upload multiple images to a location from phone.
- Admin can set an uploaded image as the hero image.
- Admin can delete uploaded media.
- Gallery pages still work at `/archive/<country>/<location>/gallery`.
- Breadcrumbs and mobile bottom navigation included.

## Deployment
Use GitHub + Netlify.

- Build command: `npm run build`
- Publish directory: `dist`

## Supabase
Run `supabase/schema.sql` in a new Supabase SQL query. This adds country status and delete policies where needed.
