
## Clay Mobile: Game View

### OBJECTIVE
  1. Push traffic to the marketplace
  2. Create an engaging experience focused on the game

### FEATURES
  1. Game is displayed - full screen
    - Scroll past URL bar on mobile
  2. Initial game load redirect (Kik only)
    - All games/apps on Kik that are in our marketplace will redirect to the marketplace (for the DAU) and open the game in Kik's native modal
    - At this stage we shouldn't jump right into having all of our apps redirect to the marketplace and open in modal
      - Start with two of our lesser-apps: Hotness Factor and Pretty Bubbles


### BACKEND/TECH
  - Inside a frame you may run into some scaling issues on iOS 5 for games that use meta tag width=device-width (Construct 2 games typically have this issue)
  - API is loaded in the parent frame
    - For [swipe bar](./swipe-bar.md)
  - Games should be accessible at subdomain.clay.io (replacing old PHP implementation)

### USERS
  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS
#### Flows into game
  1. External source -> Game on Kik -> Redirect to Marketplace -> Game View Modal Opens
  2. Internal Cross-promotion (from another game) -> Marketplace link (not direct link to game) -> Game View Modal Opens
  3. Internal Marketplace page -> Tap on game -> Game View Modal Opens

#### Flows within game
Game -> Swipe from right -> Swipe Menu opens

### WIREFRAMES
Let me know if you want/need any. I'd just take the existing swipe bar / what Cristian did for it
<img src="/../master/specs/resources/swipe-bar.png?raw=true" style="width: 250px">
  - Share game is easy enough that it should probably be done in phase 1 (basic Clay/Kik API call)
  - Skip achievements, leaderboard, personal profile for now

### PREPARING FOR NEW PLATFORMS
#### Marketplace <-> Game Flow
  - Cross promotion on Kik will go do marketplace->modal flow, elsewhere it will go directly to game
  - On platforms like Android, we might want a more obvious 'return to marketplace' that's not hidden in swipe bar
  - "More games" link (back to marketplace) will behave different on each platform
  -

#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
  - Swipe bar nub should be visible within 2 seconds of the game content first loading (3G)

### METRICS TO TRACK
**Success for our App/features**
  - Number of games played per session
  - Number of marketplace/game visits (every game session will mean at least one marketplace visit with the redirect)
**Success for game (eg we may want to account for it in how we sort/rank/display games)**
  - Session length
  - Bounce rate
  - Total plays/visits
  - Repeat plays/visits

### WHAT SUCCESS LOOKS LIKE
  - Marketplace app in top 30
  - > 4 min avg time per game
  - Users playing an average of 2 games per session (it's difficult to give an estimate for this right now)
