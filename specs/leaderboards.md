## Clay Mobile: Leaderboards

### OBJECTIVE

  1. **Encourage challenger discovery**
    - Metrics: Encounters per user, Experiences per User
  2. **Increase Engagement through competition**
    - Metrics: Average game session length, Return visitors

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - Return visitors
  - Encounters per user
    - Seeing someone's name & avatar in the leaderboard
  - Experiences per user
    - Profile views
  - Average game session length

### FEATURES

  1. Global high scores
    - **Why?** Creates competition: user vs self and user vs others that will hopefully increase engagement**
    - For now we can continue to just show top X scores (no pagination)
  2. Friends' high scores
    - **Why?** Encourages users to befriend others, and users will theoretically care more about beating friends scores
  3. Personal high score / rank
    - **Why?** Makes it clear how the user ranks and how close/far they are from having their name in lights (top x scores)
    - If user isn't in top X, still show their score/rank
  4. Easy-access mini-profile
    - **Why?** More experiences per user, better game discovery (see what friends are playing)
    - Ability to befriend them
    - See [Profile Spec](./profiles.md)
  5. Share high score
    - **Why?** Increased invites per users -> increased K-factor (# of invites sent by each user * conversion rate of invite)
    - This will be our 'challenge a friend' system for now
      - Eventually we'll do a more involved challenge system that isn't simply sharing the game

### BACKEND

  - The base for a leaderboard has already been implemented in the API, with **High scores (global and friends)**, **Personal high score/rank** and **Share high score** already existing
  - Mini-profile component for API will need to be added

### USERS

  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS
Primarily up to the developer for when they want the leaderboard to be shown.

### WIREFRAMES / MOCKUPS
[Cristian's first leaderboard mockup](./resources/leaderboards.pdf)

### NOTES

### PERFORMANCE REQUIREMENTS
N/A

### A/B TESTS

#### Sharing without connection

  - **Hypothesis:** altering the sharing mechanism to no longer require connecting a Facebook / Twitter account will increase conversion over the long-haul
  - **Primary metrics:** shares per user (over a longer period of time - eg 2 months)
