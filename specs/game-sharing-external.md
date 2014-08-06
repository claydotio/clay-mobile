
## Clay Mobile: Game Sharing (external)

### OBJECTIVE
  1. Get users sharing games to external sources
  2. Get new users playing games
  3. Get new users to the marketplace

### FEATURES
  1. Swipe bar game sharing
  2.

### FEATURES IN-DEPTH
  1. Swipe Bar
    - User swipes in from right side of page to open bar
  2. Swipe Bar Cross Promotion
    - 3 games to show
    - Pick random 3 of the 10 most popular games that have at least one category (genre) in common with the current game
    - Display game promo image. Clicking brings the user to the marketplace app on Kik, which automatically opens game modal
  3. Swipe Bar back to marketplace
    - "More games" link
    - A/B test the text/look we use to send people back to the marketplace
    - Inside Kik, this link will just close the current modal window (assuming that is technologically possible, otherwise redirect)
  4. Swipe Bar game ratings
    - Like vs Dislike (better for mobile than 5-star)
    - Give success feedback immediately, follow with error message if something went wrong on backend
  5. Initial game load redirect (Kik only)
    - All games/apps on Kik that are in our marketplace will redirect to the marketplace (for the DAU) and open the game in Kik's native modal
    - At this stage we shouldn't jump right into having all of our apps redirect to the marketplace and open in modal
      - Start with two of our lesser-apps: Hotness Factor and Pretty Bubbles

### BACKEND/TECH
#### Iframes vs Inline
  - Games can be loaded in an iframe or inline - both have advantages and disadvantages
    - To load inline, we grab HTML via cURL and change the <base href>
  - In the approval process we have a manual setting that dictates whether or not the game will be loaded in an iframe on mobile

Note: in the future I'm going to go less into this stuff - if we need to talk about it, we'll talk - it's quicker

**Iframe advantages**
  - Most external games (not hosted on Clay) will work

#### Iframe disadvantages
  - Scaling doesn't always work properly. If we have the meta width=device-width, and the game has it as well, sometimes the game doesn't display properly
  - We can't access the html of remote games

**Inline advantages**
  - Able to modify HTML of game itself
  - Scaling works

**Inline disadvantages**
  - Depending on the game/assets, we'll get CORS errors

#### API
  - Swipe bar should be based on API swipe bar (ie, use the API...)
    - This means the API should be loaded for every marketplace game
  - Like/Dislike will need to tap into backend
    - Easiest thing to do for now is to hit `http://clay.io/ajax/gameRate` with `{ allowAnon: true, game_id: gameId, vote: 1 || 5 }`

All of this exists in PHP, but should be rewritten for this because it's not the prettiest...

### USERS
1. Kik Users
  - Age: 52% 13-18, 23% 19-25, 25% 26+
  - Gender: 51% male, 49% female
  - Location: 60% North America
  - Platform: 52% iOS, 45% Android
  - Likes: Flirting, Meeting new people

### USER FLOWS
#### Flows into game
1.
External source -> Game on Kik -> Redirect to Marketplace -> Opens game in Modal

2.
Internal Cross-promotion (from another game) -> Marketplace link (not direct link to game)
-> Game Modal Opens

3.
Internal Marketplace page -> Tap on game -> Opens in Modal

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


#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
  - Swipe bar nub should be visible within 2 seconds of the game content first loading (3G)

### WHAT SUCCESS LOOKS LIKE
  - Marketplace app in top 30
  - > 4 min avg time per game
  - Users playing an average of 2 games per session (it's difficult to give an estimate for this right now)

#### Metrics that measure success
**Success for our App/features**
  - Number of games played per session
  - Number of marketplace/game visits (every game session will mean at least one marketplace visit with the redirect)
**Success for game (eg we may want to account for it in how we sort/rank/display games)**
  - Session length
  - Total plays/visits
  - Repeat plays/visits
