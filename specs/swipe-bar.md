
## Clay Mobile: Swipe Bar

**V1** of this spec. **V2** will add in game sharing (external), **V3** will add social stream

### OBJECTIVE

  1. Cross-promote between games
    - Number of games played per session
  2. Push traffic to the marketplace
    - DAU of Marketplace, Number of games played per session
  3. Give us data about the game
    - Average game session length

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
-  - **Average game session length**
-    - \> 3:00
-  - **Number of games played per session**
-    - TBD (we'll need to find a good way to track this in GA)
-  - **DAU of Marketplace**
-    - 15,000 (top 30 on Kik)

### FEATURES

  1. Swipe Bar Cross Promotion
    - *Why?* cross promotion between games (more games played per session)
    - Shows `X` number of games
    - Pick random `X` of the `Y` most popular games that are relevant (eg at least one category (genre) in common with the current game)
  2. Swipe Bar back to marketplace
    - *Why?* gives users the chance to find more games after they're done with the current one. More marketplace DAU, more games played per session
    - Something along the lines of a "More games" link (we'll text the look/text)
    - Inside Kik, this link will just close the current modal window (assuming that is technologically possible, otherwise redirect)
  3. Swipe Bar game ratings
    - *Why?* gives us better data on if the game is fun or not, which will affect the ratings and position it's shown on the marketplace (which leads to better engagement)
    - Like vs Dislike (better for mobile than 5-star)

### BACKEND/TECH
#### API
  - Swipe bar should be loaded from API
    - This means the API should be loaded for every marketplace game
  - Like/Dislike will need to tap into backend
    - Easiest thing to do for now is to hit `http://clay.io/ajax/gameRate` with `{ allowAnon: true, game_id: gameId, vote: 1 || 5 }`
    - Have like/dislike in an iframe so devs can't maliciously call the method for like
    - Give success feedback immediately, follow with error message if something went wrong on backend

### USERS
  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS
Game -> Swipe from right -> Swipe Menu opens

### WIREFRAMES
<img src="/../master/specs/resources/swipe-bar.png?raw=true" style="width: 250px">
  - Share game is easy enough that it should probably be done in phase 1 (basic Clay/Kik API call)
  - Skip achievements, leaderboard, personal profile for now

### NOTES
#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
  - Swipe bar nub should be visible within 2 seconds of the game content first loading (3G)
