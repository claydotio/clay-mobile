## Clay Mobile: Profiles

### OBJECTIVE

  1. **Encourage challenger discovery**
    - Metrics: Encounters per user, Experiences per user, Friendships per user
  3. **Promote game discovery through friends/connections**
    - One goal of profile should be to funnel the viewing user into games that the profile user plays
    - Metrics: Games played per session

-#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - Encounters per user
    - When viewing a profile, seeing their friends will count as an encounter
  - Experiences per user
    - A profile view already counts as 1 experience
    - Ideally we want this to lead to more than one experience
      - Trying to beat that user's high score, etc...
  - Friendships per user
  - Games played per session

### FEATURES

  1. Feed
    - **Why?** Keep the profiles fresh to encourage more experiences (eg user viewing someone's profile more than once), and encourage game discovery
    - Same posts as [the personal stream](./personal-stream.md), just filtered to be only the profile's owner/user
  2. List of recent games
    - **Why?** Encourage game discovery (games played per session)
    - List of recent games
  3. List of friends
    - **Why?** More encounters and experiences
  3. Add as friend
    - **Why?** More friendships
    - Needs to stand out
  4. Mini profile
    - **Why?** More experiences per user, better game discovery (see what friends are playing)
    - Pretty much everything (slimmed down) except for the feed
      - Ability to add as friend
      - Achievements, Friend Count
      - Recent games played
      - Ability to view full profile (new window)

### BACKEND

  - We already have a feed system, API posts new achievements to stream

### USERS

  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS

### WIREFRAMES / MOCKUPS

### NOTES
- Eventually we will focus more on points aka GamerScore (assuming tests go well)

### PERFORMANCE REQUIREMENTS
N/A

### A/B TESTS

#### Sharing without connection

  - **Hypothesis:** altering the sharing mechanism to no longer require connecting a Facebook / Twitter account will increase conversion over the long-haul
  - **Primary metrics:** shares per user (over a longer period of time - eg 2 months)
