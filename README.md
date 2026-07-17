## The 210 Project V4.8.1 Recovery Hotfix

This version matches the existing Supabase status values: `upcoming`, `live`, and `visited`.

### Restored
- Visited countries show the green bordered card again.
- Live country shows a blue highlighted card.
- Upcoming countries are greyed out.
- Map phase controls are back: All, South America, Asia.
- Admin can change country phase/status/summary.
- Admin can set live location without touching the location status constraint.
- Notifications auto-dismiss.
- Save buttons should not get stuck on Saving/Publishing.
- Bottom nav Map and AI work from any route.

### Deploy
1. Upload the contents of this folder to GitHub.
2. Run `supabase-v4-8-1-recovery.sql` in Supabase SQL Editor.
3. Netlify build command: `npm run build`.
4. Netlify publish directory: `dist`.
5. Keep environment variables: `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`.
