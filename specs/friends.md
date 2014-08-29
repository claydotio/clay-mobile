## Clay Mobile: Friendships

### OBJECTIVE

  1. **Close the loop on challenger discovery**
    - Metrics: Friendships per user
  2. **Increase retention by being "the place where your friend are"**
    - Metrics: Return visitors
    - This is a strong unfair advantage of any network
    - It's the reason Google+ lost/is losing vs Facebook
  3. **Promote game discovery through friends/connections**
    - Metrics: Games played per session

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - Return visitors
  - Friendships per user
  - Games played per session

### FEATURES

  1. Friends list on [profile page](./profiles.md)
  2. Ability to befriend others
    - [On profiles & mini-profile](./profiles.md)

### BACKEND

  - `friendships` table in MySQL
    - 12MM rows
    - Kik user sending message to another Kik user = friendship row insert
      - Other user sends message to original sender = friendship row updated with confirmed = 'T'

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

### PERFORMANCE REQUIREMENTS
N/A

### A/B TESTS
