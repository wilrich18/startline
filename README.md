# Start/Line

Start/Line builds a race training plan and a nutrition plan from your health details and your race.

Open `index.html` in a browser. It is one self-contained page with no build step and no server.

## What it does

- **Sign in:** create an account with your name, email and password, or continue as a guest. Each account keeps its own races and plans. With Supabase set up (below), accounts work on any device, plans are saved online, and forgotten passwords can be reset by email. Without it, accounts are stored only in the browser on that device (passwords salted and hashed with PBKDF2).
- **My races:** add, edit and delete races (name, type, date, goal time), and pick which one the plan is for. You can also create your own race types.
- **Training plan:** a week-by-week plan with base, build, peak and taper phases, every fourth week easier, and the race week built around the day of your race. Sessions and weekly totals are shown by distance (km or miles).
- **Nutrition plan:** daily calorie, carb, protein and fluid targets that follow each day's training, a carb load before longer races, and race-day fueling. "Meals this week" shows the meals and portions for any week.
- **Grocery list:** the same week's meals turned into a shopping list in the package sizes stores sell, grouped by section, with tick boxes and a copy button.

Races covered: 5K, 10K, half marathon, marathon, 50K ultra, and sprint, Olympic, half-Ironman and Ironman triathlons.

Without Supabase, everything you enter, including accounts, is saved only in your own browser.

## Turning on Supabase accounts

1. Create a free project at [supabase.com](https://supabase.com).
2. In the project, open **SQL Editor**, paste the contents of [`supabase/schema.sql`](supabase/schema.sql) and click **Run**. This creates the `startline_data` table with row-level security, so each person can only see their own data.
3. Open **Authentication > URL Configuration** and set **Site URL** to where the app is hosted (for example `https://wilrich18.github.io/startline/`). Add any other hosts, such as a Vercel URL, under **Redirect URLs**. Confirmation and password-reset emails link back here.
4. Open **Project Settings > API** and copy the **Project URL** and the **anon public** key into the `SUPABASE` line near the end of `index.html`:

   ```js
   const SUPABASE = { url: "https://YOUR-PROJECT.supabase.co", anonKey: "YOUR-ANON-KEY" };
   ```

   The anon key is meant to be public. The row-level security policies are what keep data private. Never put the `service_role` key in the app.

By default Supabase asks new users to confirm their email before signing in. You can turn that off under **Authentication > Providers > Email** if you prefer.

## Not medical advice

Start/Line gives general guidance based on common coaching and sports-nutrition ranges. Check with a doctor before starting a new training plan, especially if you have a health condition or injury.
