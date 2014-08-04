Clay Mobile: External Game Sharing
===========================

OBJECTIVE
---------
1. Help games grown organically through sharing
2. Funnel people from shared games back into marketplace app

FEATURES
--------
1. Game shares within marketplace
2. Game shares within game

FEATURES IN-DEPTH
-----------------
1. Tapping on a game brings the user directly to the game itself - no intermediary page
   This means no page we can put a share button on. For now sharing will be exclusively
   through the game page itself, within the sidebar

USERS
-----
1. Kik Users
  * Age: 52% 13-18, 23% 19-25, 25% 26+
  * Gender: 51% male, 49% female
  * Location: 60% North America
  * Platform: 52% iOS, 45% Android
  * Likes: Flirting, Meeting new people

USER FLOWS
----------
Open App -> Game List -> Choose Game -> While playing game -> Share game

WIREFRAMES
----------
game-discovery.ep

BACKEND
-------

PREPARING FOR NEW PLATFORMS
---------------------------
While we're initially developing this for sharing within Kik, it needs to scale to other
platforms. Eg. when the app is on Google Play

PERFORMANCE REQUIREMENTS
-----------------------
Initial load time (app open, content not necessarily available): < 2s on 3G
Priority: 8/10

All game images loaded time: < 5s on 3G
Priority: 6/10

For this stage we're looking at 10k-15k DAU and likely no more than 100-150 concurrent (in-line with top 40 metric)

WHAT SUCCESS LOOKS LIKE
-----------------------
We want this version of the app to consistently stay in the **top 40** on Kik. To do so, we'll have to drive a
good bit of traffic to it (since there's no inherent sharing in the app). We'll also have to update the Clay
sidebar to link to this app from every game on Kik.

Top 40 on Kik translates to ~300,000 uniques / month

Push tokens for all users, no email yet (next stage of app)
