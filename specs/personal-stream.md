## Clay Mobile: Social Stream

### OBJECTIVE

  1. **Encourage challenger/friend discovery**
    - Metrics: Encounters per user, Experiences per User
    - Stream view = encounter which can lead to experiences (eg profile view) and friendships
  2. **Encourage game discovery**
    - Metrics: Games played per session
    - See what friends are playing, join them in those games - either synchronously (multiplayer/co-op) or async (high scores)
  3. **Promote return visits with up-to-date content from friends (the Facebook stream effect)**
    - Metrics: Return visitors

-#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - Return visitors
  - Encounters per user
  - Experiences per user
    - Social stream will need to be able to convert encounters to experiences (eg clicking on a profile, or playing a friend in a game)
  - Games played per session

### FEATURES

  1. List of status updates
    - **Why?** More encounters per user (reading others 'status' updates)
    - Consists of:
      - Achievements earned
      - High scores
      - Custom message / status
    - Initial version can be based on time (most recent updates). Eventually we'll have an algorithm for what is shown
  2. Easy-access mini-profile
    - **Why?** More experiences per user
    - Ability to befriend them
    - Could A/B test full-featured "mini" vs light "mini" with accompanying [full profile](./profile.md)
      - Would test for # of friendships, and number of interactions (clicks/actions within profile)
  3. Ability to access profile via the stream
    - **Why?** more experiences per user, which hopefully leads to friendships
    - Either have the mini-profile be the entire experience, or have a separate profile page

### BACKEND

  - There is existing 'stream' architecture in MySQL (`stream` table)
    - Might be worth thinking about whether or not that's the best setup for this

### USERS

  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS

Open App -> Click "Social" tab -> View Stream
                                              |
                                               -> Click a profile link
                                               -> Click stream item (eg redirect to game)

### WIREFRAMES
N/A

### NOTES

### PERFORMANCE REQUIREMENTS
N/A

### A/B TESTS

#### App first load page/tab

  - **Hypothesis:** making the social stream be the first page opened in the app will increase retention and user discovery with a negligible affect on games played per session
  - **Primary metrics:** experiences per user, return visitors, number of games played per session
