
## Clay Mobile: Swipe Bar

**Current: V2** game sharing (external)
**V1** of this spec was for Game Discovery
V3 will add social stream

### OBJECTIVE

  1. **Cross-promote between games**
    - Number of games played per session
  2. **Push traffic to the marketplace**
    - DAU of Marketplace, Number of games played per session
  3. **Improve retention for games**
    - Returning visitors
  4. **Give us data about the game**
    - Average game session length

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - **Average game session length**
    - \> 3:00
  - **Returning Visitors**
    - TBD
  - **Number of games played per session**
    - TBD (we'll need to find a good way to track this in GA)
  - **DAU of Marketplace**
    - 15,000 (top 30 on Kik)

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
    - 5 star system initially, we'll also test thumb up/down
    - For now we won't require auth to rate. 1 rating per game per IP/user
  4. Swipe Bar save game / add to collection
    - ** Not in Phase 2 **
    - **Why?** Improve retention for games (make it easy for users to re-play ones they like)
    - Must be logged in to work
    - If not logged in, the link looks the same, but when clicked the user is prompted to login
      - Prompt should be our generic login/signup screen ([this is what it currently looks like](http://grab.by/zO26)) but with context (eg. Login/signup to save this game, and so much more)
        - OR we can give them the context screen with a button to signup, if it makes more sense
      - Should default to signup

### BACKEND/TECH
#### API
  - Swipe bar should be loaded from API
    - This means the API should be loaded for every marketplace game
  - Like/Dislike will need to tap into backend
    - Easiest thing to do for now is to hit `http://clay.io/ajax/gameRate` with `{ allowAnon: true, game_id: gameId, vote: 1 || 5 }`
    - Have like/dislike in an iframe so devs can't maliciously call the method for like
    - Give success feedback immediately, follow with error message if something went wrong on backend
  - Saving games already exists (`installed`) table in MySQL

### USERS
  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS
Game -> Swipe from right -> Swipe Menu opens

### WIREFRAMES / MOCKUPS
  - [Android](https://drive.google.com/a/clay.io/file/d/0B6lT1VqTB05reGlSSkZWZWk0VVk/edit?usp=sharing)
  - [iOS](https://drive.google.com/a/clay.io/file/d/0B6lT1VqTB05rZ3RVSl9Wb3QtTE0/edit?usp=sharing)

### NOTES
#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
  - Swipe bar nub should be visible within 2 seconds of the game content first loading (3G)

### A/B TESTS

#### Icons instead of Promo (440) Images

  - **Hypothesis:** Icons with the game name will lead to more clicks to other games
    - More targeted games for the player / their current mood
  - **Control:** Promo 440
  - **Primary metrics:** number of games played per session, bounce rate for games

#### Nub Positioning

  - **Hypothesis:** A different nub position will lead to more swipe opens with actions
  - **Variations:** Top, bottom, Kik's positioning (mirrored)
  - **Primary metrics:** number of actions inside swipe bar (share, rate, etc...)
    - Tracking just swipe opens wouldn't give us a good idea if most of those were on accident because of poor placement
    - Could also track number of swipe opens without an action, and treat is as a bounce rate

#### Thumb up / Thumb down

  - **Hypothesis:** A thumbs rating system would lead to more games played per session and more ratings per user
    - The primary case for this would be users like to see a green/red Youtube style bar (or some other UI) to indicate good games
  - **Primary metrics:** number of games played per session, ratings per user
