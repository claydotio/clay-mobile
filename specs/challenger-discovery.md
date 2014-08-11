## Clay Mobile: Challenger Discovery

### OBJECTIVE

  1. **Encourage users to engage with new people (challengers)**
    - Metrics: Encounters per user, Experiences per user, Friends per user
  2. **Create a social graph of gamers**
    - Metrics: Friends per user
    - More friends (usually) means more engagement. People want to play games where their friends are
      - A strong social graph can become an unfair advantage for us

-#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - Friends per user
  - Experiences per user
    - Challenges, wall posts, playing against them in a game, viewing someone's profile
    - friend:experiences:encounters lets us measure how many are following through from experiences to encounters to full-on friends
  - Encounters per user
    - Seeing another person's name & avatar (eg in leaderboards, the social stream, etc...)
    - Lets us measure how many people we are putting in front of the user
      - friend:experiences:encounters lets us measure how many are following through from experiences to encounters to full-on friends

### FEATURES

  1. Leaderboards
    - **Why?** leads to more encounters per user and more engagement in games (attempting to beat others' scores)
    - Separate spec: [leaderboards.md](leaderboards.md)
  2. Profiles
    - **Why?** more experiences per user and people love their vanity
    - Separate spec: [profiles.md](profiles.md)
  3. Friend System
    - **Why?** friends per user, basis of social graph
    - Separate spec: [friends.md](friends.md)

### BACKEND

  - Most of this should be integrated into the API backend so developers can enable this challenger discovery in their games
  - We're logging all friendships on Kik (and outside of it) in the `friendships` column
    - Right now our idea of friendships on Kik is essentially just the concept of experiences (detailed above), with a `confirmed` boolean that is true if both users have initiated an event to the other

### USERS

  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS

  - Will be laid out in individual feature specs

### WIREFRAMES
N/A

### NOTES

### PERFORMANCE REQUIREMENTS
N/A

### A/B TESTS

#### TBD
