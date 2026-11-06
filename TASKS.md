# My Campus Life - Upcoming Tasks Roadmap

This file contains the remaining external configuration task that still needs to be done. It does not list finished items. All in-game features, 16 campus rooms, 5 camera views, anti-lag optimizations, crisp text sanitizers, and wholesome mini-games are complete and tested.

---

## Task 1: Connect Google Sign-In with Supabase & Google Cloud Console

### Overview
Connect your Google OAuth credentials in Google Cloud Console and your Supabase Dashboard so students can sign in with one tap using their real Google account. The in-game Google Sign-In button, cloud student profile sync, and redirect handler are already fully built in web_shell.html.

---

### Step 1: Find Your Supabase Project Reference & Callback URL
1. Open your Supabase Dashboard at https://supabase.com/dashboard
2. Click on your My Campus Life project.
3. Look at your browser address bar. The URL looks like:
   https://supabase.com/dashboard/project/YOUR_PROJECT_ID
   Note down this YOUR_PROJECT_ID string (e.g. qissxomdrgimimkedwpy).
4. Your Supabase Google Auth Callback URL is:
   https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback
   (Example: https://qissxomdrgimimkedwpy.supabase.co/auth/v1/callback)
   Copy this callback URL. You will need it in Google Cloud Console.

---

### Step 2: Set Up Google Cloud Console Project & OAuth Consent Screen
1. Open Google Cloud Console at https://console.cloud.google.com/
2. Sign in with your Google account (Marvellous Adepoju / Marvel Develops).
3. At the top left next to the Google Cloud logo, click the Project dropdown and click "NEW PROJECT".
   - Project name: My Campus Life
   - Organization: No organization (or your organization if you have one)
   - Click "CREATE" and wait a few seconds for it to finish creating.
   - Select your new "My Campus Life" project from the top dropdown.
4. In the left navigation menu, click "APIs & Services", then click "OAuth consent screen".
   - User Type: Select "External" (this allows any student with a Google account to log in).
   - Click "CREATE".
5. Fill in the "App information" page:
   - App name: My Campus Life
   - User support email: Select your email address from the dropdown.
   - App logo: Optional (you can upload logo.svg or skip for now).
   - Application home page: https://mycampuslife.vercel.app
   - Application privacy policy link: https://mycampuslife.vercel.app (or your website https://marveldevelops.com)
   - Application terms of service link: https://mycampuslife.vercel.app
   - Authorized domains: Click "ADD DOMAIN" and type:
     supabase.co
     vercel.app
   - Developer contact information: Enter your email address (e.g. your personal or Marvel Develops email).
   - Click "SAVE AND CONTINUE".
6. "Scopes" page:
   - The default basic scopes (email, profile, openid) are automatically included.
   - You do not need any sensitive scopes.
   - Scroll to the bottom and click "SAVE AND CONTINUE".
7. "Test users" page:
   - While your app is in "Testing" mode, only added test users can sign in.
   - Click "+ ADD USERS".
   - Type your own Google email address (and any friend or test accounts you want to use).
   - Click "ADD".
   - Click "SAVE AND CONTINUE".
8. Summary page:
   - Review your settings and click "BACK TO DASHBOARD".

---

### Step 3: Create OAuth 2.0 Web Client Credentials
1. Still in Google Cloud Console under "APIs & Services", click "Credentials" in the left sidebar.
2. At the top of the page, click "+ CREATE CREDENTIALS", then select "OAuth client ID".
3. Fill in the form:
   - Application type dropdown: Select "Web application".
   - Name: My Campus Life Web Client
4. Under "Authorized JavaScript origins", click "+ ADD URI" and add the following two URLs:
   - URI 1: https://mycampuslife.vercel.app
   - URI 2: http://localhost:8000
   (Add http://localhost:3000 as URI 3 if you run local node servers).
5. Under "Authorized redirect URIs", click "+ ADD URI" and paste your Supabase callback URL from Step 1:
   - https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback
   (Double check that there is no trailing slash after callback).
6. Click "CREATE" at the bottom of the page.
7. A dialog box titled "OAuth client created" will pop up displaying:
   - Client ID (a long string ending in .apps.googleusercontent.com)
   - Client Secret (a secret key string)
8. Copy both the Client ID and the Client Secret to your notepad.

---

### Step 4: Configure Google Provider in Supabase Dashboard
1. Go back to your Supabase Dashboard at https://supabase.com/dashboard/project/YOUR_PROJECT_ID
2. In the left navigation bar, click on "Authentication" (the icon with the lock or users).
3. Under the Authentication sub-menu, click on "Providers".
4. Scroll down the list of providers until you see "Google". Click on "Google" to expand its settings.
5. Toggle the switch "Enable Google provider" to ON (switch turns green).
6. Paste your credentials:
   - Client ID: Paste the Client ID you copied from Google Cloud Console.
   - Client Secret: Paste the Client Secret you copied from Google Cloud Console.
7. Click the green "Save" button at the bottom of the Google provider card.

---

### Step 5: Configure Allowed Redirect URLs in Supabase
1. Still in the Supabase Dashboard under "Authentication", click on "URL Configuration" in the sub-menu.
2. In the "Site URL" field, set:
   https://mycampuslife.vercel.app
3. Under "Redirect URLs", ensure your game domain is allowed by clicking "Add URL" for each:
   - https://mycampuslife.vercel.app
   - https://mycampuslife.vercel.app/*
   - http://localhost:8000
   - http://localhost:8000/*
4. Click "Save".

---

### Step 6: Verify in the Live Game
1. Open https://mycampuslife.vercel.app in your browser.
2. On the Admissions Studio screen, you will see the white "Continue with Google" button.
3. Click "Continue with Google".
4. You will be redirected to Google's official sign-in screen.
5. Select your Google account (make sure it is in your Test Users list if your Google Cloud app is in Testing mode).
6. Google will authenticate you and redirect back to https://mycampuslife.vercel.app
7. The Admissions Studio will confirm your identity, load your cloud student profile (or prompt you to pick your outfit and department if it is your first time), and enter the campus!
8. When ready for all students worldwide to sign in without adding their emails to Test Users, return to Google Cloud Console -> "OAuth consent screen" and click "PUBLISH APP" to make it public.
