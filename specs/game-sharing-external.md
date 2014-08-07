
## Clay Mobile: Game Sharing (external)

### OBJECTIVE
  1. Get users sharing games to external sources
  2. Get new users playing games
  3. Get new users to the marketplace

### FEATURES
  1. Swipe bar game sharing
  2. Game info page sharing

### FEATURES IN-DEPTH
  1. Swipe Bar game sharing
    - **Share Game** link in swipe bar
    - Tapping on link gives user option to share via multiple sources: Kik, Twitter, Facebook
      - We decide the best sharing method (eg Kik inside of Kik) and highlight that one

  2. Game info page sharing
    - Game info page consists of promotional images/text, reviews, and sharing options
      - Will probably have separate spec sheet for it when we get to that point
    - This won't be implemented until we are testing whether or not the game info page is a good idea


### BACKEND/TECH
#### API
  - API should already be in each game page from the "game-view" phase
  - Social Sharing (eg `Clay.Social.smartShare`)
    -Spread across 4 classes: `Clay.Social` (general), `Clay.Facebook`, `Clay.Twitter`, `Clay.Kik`
    - The `.coffee` files should have decent documentation on how to do this - same goes for the [docs](http://clay.io/docs)

### USERS
1. Kik Users
  - Age: 52% 13-18, 23% 19-25, 25% 26+
  - Gender: 51% male, 49% female
  - Location: 60% North America
  - Platform: 52% iOS, 45% Android
  - Likes: Flirting, Meeting new people

### USER FLOWS


### WIREFRAMES
Let me know if you want/need any. I'd just take the existing swipe bar / what Cristian did for it
<img src="/../master/specs/resources/swipe-bar.png?raw=true" style="width: 250px">
  - Share game is easy enough that it should probably be done in phase 1 (basic Clay/Kik API call)
  - Skip achievements, leaderboard, personal profile for now

### PREPARING FOR NEW PLATFORMS
#### Marketplace <-> Game Flow
  -


#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
  -

### METRICS TO TRACK
In order of importance
  - K-Factor (# of invites sent by each user * conversion rate of invite)
    - Shares sent by each user (overall and per session)
      - Track the source (eg sharing to Facebook, Twitter)
    - Inbound users from shares
      - Track the source (eg incoming from Facebook, Twitter)

### A/B TESTS
We'll run tests as follows:



### WHAT SUCCESS LOOKS LIKE
  - K-factor > 1
