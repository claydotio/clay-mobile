## Clay Mobile: Game Info Page

This will be run as an A/B test for [Game Discovery]()

### OBJECTIVE

  1. **Help users get into the right games for them**
    - Metrics: Game session length, games played per session
  2. **Get users sharing games**
    - Metrics: K-factor

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - **Average game session length**
    - \> 3:00
  - **Number of games played per session**
    - TBD (we'll need to find a good way to track this in GA)
  - **K-Factor**
    - > 1

### FEATURES

  1. Game Description
    - **Why?** Make it clear what the game is about...
  2. Game Promo Material
    - **Why?** Gives the user a quick taste of the game
    - Images, potentially videos
  3. Reviews / Ratings
    - **Why?** People care about how others rate games
  4. Sharing Options
    - **Why?** Increase K-factor for a game
    - Even on Kik I think we can implement Facebook, Twitter and Kik sharing


### BACKEND/TECH
#### API
  - Ratings/reviews will need to tap into backend
    - Easiest thing to do for now is to hit `http://clay.io/ajax/gameRate` with `{ allowAnon: true, game_id: gameId, vote: 1 || 5 }`
    - Give success feedback immediately, follow with error message if something went wrong on backend
    - Ratings table is `ratings`. Comment (review) is optional

### USERS
  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS


### WIREFRAMES / MOCKUPS
  - [Mockup](https://drive.google.com/#folders/0B6lT1VqTB05rN2dscXlBcHRDam8)

### NOTES
#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo/header/media images

### PERFORMANCE REQUIREMENTS

### A/B TESTS

#### Adding "Add to Collection Button"

  - **Hypothesis:** Having an add to collection button won't negatively affect any metric, and will improve our number of returning visitors
  - **Primary metrics:** returning visitors
