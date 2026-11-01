# My Campus Life - Upcoming Tasks Roadmap

This file contains all the tasks that still need to be done. It does not list finished items. Each task explains what needs to be created and how to build it. All features are designed to be wholesome, fun, clean, and engaging for all players.

---

## Task 1: Connect Google Sign In with Supabase
### What Needs to be Done
Connect Google OAuth credentials so players can sign in with one tap using their real Google account.

### How to Do It
1. Open Google Cloud Console under Credentials.
2. Create an OAuth 2.0 Client ID for Web application.
3. Add https://mycampuslife.vercel.app and http://localhost:8000 under Authorized JavaScript Origins.
4. Add https://qissxomdrgimimkedwpy.supabase.co/auth/v1/callback under Authorized Redirect URIs.
5. Copy the Client ID and Client Secret into the Supabase Dashboard under Authentication Providers Google.
6. Test in web shell that clicking the Google button signs the user in and restores their cloud profile.

---

## Task 2: Hostel Room Customization and Study Hub
### What Needs to be Done
Allow players to personalize their hostel room with useful furniture, study lamps, bookshelves, and home decor.

### How to Do It
1. In mall items data gd, add new placeable room items such as Study Lamp, Double Deck Bookshelf, QASA Standing Fan, Ergonomic Desk Chair, and Campus Map Wall Poster.
2. In base room gd, save owned furniture in student profile and display them in the hostel room upon entry.
3. High level study furniture grants passive study focus buffs, speeding up exam preparation.

---

## Task 3: Driveable Campus Danfo Bus and Keke Shuttle
### What Needs to be Done
Let players drive the yellow Danfo bus or tricycle Keke around the campus ring road to transport students between faculties.

### How to Do It
1. In campus gate scene, place an interactive yellow Danfo bus.
2. Create simple arcade vehicle physics with forward drive, reverse, steering, and braking.
3. Place passenger stops at Hostel, Lecture Hall, Library, and Stadium.
4. Picking up waiting student NPCs and dropping them at their destination rewards 150 Naira transport fare per trip.
