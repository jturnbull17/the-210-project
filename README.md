## The 210 Project V4.8 Recovery Hotfix

This recovery build restores the parts that regressed:

- Completed countries show a green bordered card again.
- Countries can be switched between Planned, Live and Completed.
- Map phase controls are back: All, South America and Asia.
- Admin has simple country phase/status/summary controls.
- Admin can set a live location.
- Notifications auto-dismiss after a short period.
- Publishing/save buttons leave their loading state after save completes.
- Bottom nav Map and AI work from any route.
- AI section scrolls into the centre of the screen.
- Insert token button is not included.

### Deploy

1. Upload the contents of this folder to GitHub.
2. In Supabase SQL Editor, run `supabase-v4-8-recovery.sql`.
3. In Netlify, keep:
   - Build command: `npm run build`
   - Publish directory: `dist`
4. Make sure Netlify environment variables are set:
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`

### Testing checklist

- Completed countries have a green border.
- Planned countries are greyed out.
- Map phase buttons filter countries correctly.
- Admin login works.
- Save country summary/status changes the archive card.
- Set live location changes the selected live location without getting stuck on Publishing/Saving.
