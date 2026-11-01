# My Campus Life - Upcoming Tasks Roadmap

This file contains all the tasks that still need to be done. It does not list finished items. Each task explains what needs to be created and how to build it. All features are designed to be wholesome, fun, clean, and engaging for all players with strong Christian values.

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

## Task 2: Mama Put Canteen Serving and Nigerian Food Mini Game
### What Needs to be Done
Allow students to work an honest lunch shift at Mama Put canteen to earn extra pocket money and free meals by assembling authentic Nigerian food plates for hungry coursemates.

### How to Do It
1. In mama put scene and food menu gd, add a Work Canteen Shift button.
2. Create a fast plate assembly minigame where student NPC customers order specific combos such as Smoky Jollof with Fried Plantain and Chicken, or Pounded Yam with Egusi and Goat Meat.
3. The player selects the correct food items on the serving trays before the timer expires.
4. Serving plates correctly rewards 400 to 800 Naira per customer, restores student hunger by 40 percent, and earns positive compliments from Mama Cashout.

---

## Task 3: Campus Fellowship Scripture Sword Drill and Devotional Challenge
### What Needs to be Done
Add a wholesome Christian fellowship daily devotional challenge and Bible study quiz at the Chapel Hall altar bench.

### How to Do It
1. In campus objects 3d gd, expand the fellowship altar interaction to open the Fellowship Scripture Challenge modal.
2. Present uplifting questions based on Proverbs, Psalms, Matthew, and Romans covering wisdom, perseverance, academic diligence, and brotherly love.
3. Answering questions rewards 50 Faith points, removes study fatigue, and provides a fellowship love offering of 1000 Naira from fellowship alumni.

---

## Task 4: Grand Convocation Ceremony and Degree Honors Certificate
### What Needs to be Done
Celebrate the player graduation at the Convocation Hall when completing the academic semesters with high CGPA.

### How to Do It
1. In convocation hall tscn and senate building gd, track when a student finishes all required semester courses.
2. When eligible, allow the student to wear the academic gown and mortarboard cap and walk up the ceremonial stage.
3. The Vice Chancellor congratulates the student and presents a Degree Honors Certificate based on final CGPA (First Class, Second Class Upper, or Second Class Lower).
4. Provide a 1-tap WhatsApp and PNG badge download so players can share their graduation achievement with friends.
