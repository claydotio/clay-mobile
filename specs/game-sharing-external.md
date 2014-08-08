
## Clay Mobile: Game Sharing (external)

### OBJECTIVE
  1. **Get users sharing games to external sources (Kik, Twitter, Facebook initially)**
    - Metrics: K-Factor
  2. **Get new users from outside sources playing games (via external sharing)**
    - Most important outside sources are Facebook and Twitter (so we can have more diversity)
    - Metrics: K-Factor

#### SUMMARY OF METRICS
In order of importance
  - K-Factor (# of invites sent by each user * conversion rate of invite)
    - \>= 1

### FEATURES
  1. Swipe bar game sharing
  2. Game info page sharing

### FEATURES IN-DEPTH
  1. Swipe Bar game sharing
    - **Share Game** link in swipe bar, when tapped we give the user options on where to share the game
  2. Game info page sharing
    - Separate spec will be made for the game info page when the time is right
    - Game info page consists of promotional images/text, reviews, and sharing options
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
N/A

### WIREFRAMES
<img src="/../master/specs/resources/swipe-bar.png?raw=true" style="width: 250px">
  - Share game is easy enough that it should probably be done in phase 1 (basic Clay/Kik API call)
  - Skip achievements, leaderboard, personal profile for now

### NOTES
#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
  - TBD
