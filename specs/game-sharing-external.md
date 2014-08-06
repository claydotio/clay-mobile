
## Clay Mobile: Game Sharing (external)

### OBJECTIVE
  1. Get users sharing games to external sources
  2. Get new users playing games
  3. Get new users to the marketplace

### FEATURES
  1. Swipe bar game sharing

### FEATURES IN-DEPTH
  1. Swipe Bar game sharing
    - **Share Game** link in swipe bar
    - Tapping on link gives user option to share via multiple sources: Kik, Twitter, Facebook
      - We decide the best sharing method (eg Kik inside of Kik) and highlight that one

### BACKEND/TECH
#### API
  - Social Sharing (eg `Clay.Social.smartShare`)
    -Spread across 4 classes: `Clay.Social` (general), `Clay.Facebook`, `Clay.Twitter`, `Clay.Kik`

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
  - Shares per game session (overall and by-source)
  - K-Factor (# of invites sent by each user * conversion rate of invite)
  - Inbound users from shares (overall and by-source)
  -

### WHAT SUCCESS LOOKS LIKE
  - K-factor > 1
