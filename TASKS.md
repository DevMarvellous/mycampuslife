# My Campus Life - Upcoming Tasks Roadmap

This file contains the remaining external configuration task that still needs to be done. It does not list finished items. All in-game features, 16 campus rooms, 5 camera views, anti-lag optimizations, crisp text sanitizers, and wholesome mini-games are complete and tested.

---

## Task 1: Connect Google Sign In with Supabase
### What Needs to be Done
Connect your Google OAuth credentials in Google Cloud Console and Supabase Dashboard so players can sign in with one tap using their real Google account. The in-game Google Sign In button and Supabase session restore logic are already built in web_shell.html.

### How to Do It
1. Open Google Cloud Console and go to APIs and Services, then Credentials.
2. Create an OAuth 2.0 Client ID and select Web application.
3. Add https://mycampuslife.vercel.app and http://localhost:8000 under Authorized JavaScript Origins.
4. Add https://qissxomdrgimimkedwpy.supabase.co/auth/v1/callback under Authorized Redirect URIs.
5. Copy the generated Client ID and Client Secret into your Supabase Dashboard under Authentication, then Providers, then Google.
6. Test in the live web game that clicking the Google button signs the user in and restores their cloud student profile.
