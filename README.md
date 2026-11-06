<p align="center">
  <img src="./docs/logo_horizontal.svg" alt="My Campus Life Banner" width="720"/>
</p>

<p align="center">
  <strong>The Ultimate Nigerian University Life-Simulator & Social Multiplayer World</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Engine-Godot%204.7.2%20Compatibility-478cbf?logo=godotengine&logoColor=white" alt="Godot 4.7"/>
  <img src="https://img.shields.io/badge/Platform-WebAssembly%20%2F%20WebGL%202-00599c?logo=webassembly&logoColor=white" alt="WebAssembly"/>
  <img src="https://img.shields.io/badge/Cloud%20Database-Supabase%20PostgreSQL-3ecf8e?logo=supabase&logoColor=white" alt="Supabase"/>
  <img src="https://img.shields.io/badge/Hosting-Vercel-black?logo=vercel&logoColor=white" alt="Vercel"/>
  <img src="https://img.shields.io/badge/Departments-34%20Across%207%20Faculties-f59e0b" alt="Departments"/>
</p>

---

## 🎓 About My Campus Life

**My Campus Life** is an authentic, vibrant, and wholesome Nigerian university life-sim browser game built on strong Christian values. Experience the full student journey from JAMB/Post-UTME admissions, faculty placement, 8:00 AM lectures in LT1, hostel cooking, Mama Put bukaterias, Campus Fellowship worship & Scripture drills, student entrepreneurship, and Senate 100L–400L promotions all the way to graduation in the Grand Convocation Hall!

### ✨ Key Features
- **⚡ Instant 0ms Load, Crisp Typography & 60 FPS Anti-Lag Engine**:
  - Clean 2D HTML/SVG Student Studio with zero perceived load time and background WASM asset streaming.
  - Automatic Unicode & Dingbat Glyph Sanitizer (`RoomManager.clean_godot_text`) ensuring zero missing `□` font boxes across WebGL and mobile devices.
  - Sleeping `SubViewport` rendering (`UPDATE_DISABLED` when closed), procedural prop shadow/GI culling, and 10 Hz network puppet throttling for smooth 60 FPS performance.
- **🎥 5 Dynamic Camera Perspective Views**:
  - Cycle anytime via the 1-tap HUD **`▲ View`** button, Web toolbar, or `V` key: **`Top View`**, **`Street View`**, **`Close-Up`**, **`Bird's Eye`**, and **`Wide Campus`**.
- **🌐 Realtime Multiplayer ($0 Serverless Architecture)**:
  - Broadcast room presence via Supabase Realtime Channels & multi-tab BroadcastChannel.
  - See coursemates in real time with synchronized 3D outfits, melanin tones, and hairstyles.
  - Staff NPCs labeled clearly with `[NPC]` tags so real students stand out.
  - Shared UTC Campus Clock (`07:00 – 22:00` day/night cycle) across all players globally.
- **💳 CampusPay P2P Money Transfers**: Send and receive live in-game allowance transfers (`₦`) to coursemates in the room or via the in-game Smartphone Banking App.
- **🎮 Wholesome Campus Mini-Games, Hustles & Live Opportunities (Zero Wagering)**:
  - **Driveable 3D Danfo Campus Shuttle**: Drive passengers around the 3D Campus Ring Road circuit to earn honest transport fares.
  - **Mama Put Canteen Serving Shift**: Assemble hot Jollof, Swallow, Suya, and Dodo orders during the lunch rush.
  - **Campus Fellowship Praise Concert & Scripture Sword Drill**: Play 4-lane gospel keyboard harmonies and memorize Bible verses to build Faith & Peace of Mind.
  - **Inter-Department Academic Quiz Tournament**: Compete for your Faculty with 50/50, Coursemate Whisper, and Lecturer Hint lifelines.
  - **Dean's Cup 5-Shot Penalty Shootout & 100m Track Sprint**: Pure-skill athletics tournaments for scholarship prizes.
  - **SUB 9-Ball Snooker Championship**: 3 free-entry skill tiers (*Practice Table*, *Inter-Hall League*, and *SUG Championship*) with tighter pro pockets.
  - **Interactive Campus Opportunities**: Live two-choice campus dilemmas (Emergency Tutorials, Lost Smart ID Card, Hostel Generator Co-Op, Dean's Research Assistantship, Tech Hub Pitch, and Chapel Welfare).
  - **Hostel Accommodation Tiers & Campus Chemist**: Upgrade from *Standard Shared Bunk* to *Corner Executive Bunk*, *VIP Self-Contain Suite*, and *Presidential Honours Suite*, and stock up on Vitamin C Packs and Treated Mosquito Nets.
  - **100L → 400L Senate Level Progression & Grand Convocation**: Advance from 100L Fresher to 400L Finalist at the Senate Registry and receive your official Honours Degree Certificate.
- **🏛️ 16 Interactive Campus Locations**:
  1. Main Campus Courtyard & Quad
  2. Moremi Hall (Female) & Hall 2 (Male) Hostels
  3. Faculty Lecture Theatre 1 (LT1) & Science LT2
  4. Central University Library & Past Questions Archives
  5. Mama Put Bukateria & Canteen
  6. Madam Kikelomo Campus Mall & Fashion Boutique
  7. Silicon Lagoon Tech Hub & Campus Clinic
  8. Student Union Building (SUB) & 9-Ball Snooker Championship Hall
  9. Sports Complex & Football Stadium
  10. University Fellowship Chapel
  11. Executive Barbing & Styling Salon
  12. Campus Botanical Gardens & Peace Park Gazebo
  13. Main Campus Security Gate & Danfo Shuttle Park
  14. University Senate & Registry Building
  15. Great Hall of Convocation & Alumni Arena
  16. Admissions Matriculation Booth
- **📱 In-Game Smartphone**: AMOLED wallpapers, Schedule Tracker, Campus Gigs & Hustles, Bank App, Live Player Lobby with 1-click room teleport, and WhatsApp-style Chat.

---

## 🎨 Official Brand Logos & App Icons

| Asset | Preview | Description |
| :--- | :--- | :--- |
| **Social Share Banner (OG)** | [`docs/og-preview.jpg`](./docs/og-preview.jpg) | 1200×630 share card for WhatsApp, Twitter, Facebook |
| **Horizontal Banner** | [`docs/logo_horizontal.svg`](./docs/logo_horizontal.svg) | Full banner with emblem, title, and badges |
| **Square Vector Crest** | [`docs/logo.svg`](./docs/logo.svg) | 3D mortarboard, gold Naira sign, and laurel crest |
| **Minimal Icon** | [`docs/logo_minimal.svg`](./docs/logo_minimal.svg) | Clean squircle icon for favicons and web apps |
| **3D App Icon (v1)** | [`docs/app_icon_v1.jpg`](./docs/app_icon_v1.jpg) | High-detail 3D render with gold rim lighting |
| **3D App Icon (v2)** | [`docs/app_icon_v2.jpg`](./docs/app_icon_v2.jpg) | 3D render with embossed "MCL" varsity ribbon |
| **3D App Icon (v3)** | [`docs/app_icon_v3.jpg`](./docs/app_icon_v3.jpg) | High-contrast centered crest edition |

---

## 🛠️ Tech Stack & Architecture

- **Game Engine**: Godot 4.7.2 (GL Compatibility Renderer / WebGL 2)
- **Frontend Web Shell**: HTML5, Responsive CSS3, SVG Vector Mannequins, Canvas 2D Snooker Physics
- **Cloud Backend**: Supabase (PostgreSQL 15, Row-Level Security, GoTrue Auth, Realtime Phoenix Channels)
- **Deployment**: Vercel Serverless (`vercel.json` with build-time environment variable injection)

---

## 🚀 Live Website

Play live: **[mycampuslife.vercel.app](https://mycampuslife.vercel.app)** *(or via custom domain)*

