Clay Mobile: Game Discovery
===========================

OBJECTIVE
---------
1. Get users playing games they might be interested in
2. Be the central point of discovery for game on Kik

FEATURES
--------
1. List of games
2. Ability to view more games through scrolling (infinite pagination)
2. Ability to filter games by category
3. Ability to sort by rating and date

FEATURES IN-DEPTH
1. LIST OF GAMES
Defaults to 15 most-popular games, where most-popular is currently defined as:
  -2 * price // try to show more free games since paid ones don't do well
+ IF rating > 0 then ( rating - 2.5 ) * SQRT( LOG10( votes ) ) ELSE 0 // take into account both avg rating & # of votes
+ staff_mobile_rating ^ 3 // our own rating can count for a lot (up to 125)
+ IF featured THEN 20 else 0 // give featured games more weight
+ IF lastupdate (timestamp) THEN LOG10(lastupdate) ELSE 0
+ IF add_time > 0 THEN LOG2( add_time - 1325376000 ) ^ 1.8 ELSE 0 

2. ABILITY TO VIEW MORE GAMES THROUGH SCROLLING
When the user scrolls at least 2/3 down the page, 15 new games are loaded. For now, we can do this pretty
rudimentarily - eventually we'll want to do something (eg remove from DOM) with the initial games that are
no longer in view (for memory reasons). Facebook and LinkedIn had to do something similar with their HTML5
apps.

3. Ability to filter games by category
The full list of categories isn't shown at first, just a "Categories" button. Tapping on this button expands
the list of categories:  
Action, Multiplayer, Shooter, Adventure, RPG, Sports, Racing, Strategy, Defense, Puzzle, Arcade, Educational

4. Ability to sort by rating and date
We'll have to consult with Cristian to get a better idea of the UX for this and the categories in a later version
of the app. For now we can have a toggle beneath the categories.

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
Open App -> Game List -> Choose Game
                      |
                      -> Choose categor(ies) -> Choose game
                      |
                      -> Change sorting -> Choose game

WIREFRAMES
----------
game-discovery.ep

BACKEND
-------
For now we'll continue to grab game data from MySQL since the entire developer dashboard is based on MySQL.

I suggest a separate Node.js server for this app with routes to:

### Grab games
* Limit
* Offset
* Categories (similar to tagging, we want to be able to pass multiple categories as array)
* Sort (popularity, recent, potentially more in future like 'recommendation rating')
* Sort Direction (ASC/DESC)

Response:
JSON encoded object { offset: int, count: int, categories: array, games: array }
Each game object in the games array will need: { name: string, description: string, promoImage: string(url), rating: double, promoStatus: string }
** promoStatus will either be featured or empty string. I don't want this as a boolean, because we may have varying levels of 'featured'

Needs to be horizontally scalable

PERFORMANCE REQUIREMENTS
-----------------------
Initial load time (app open, content not necessarily available): < 2s on 3G
Priority: 8/10

All game images loaded time: < 5s on 3G
Priority: 6/10

50,000 Concurrent users per server?

WHAT SUCCESS LOOKS LIKE
-----------------------
We want this version of the app to consistently stay in the **top 40** on Kik. To do so, we'll have to drive a 
good bit of traffic to it (since there's no inherent sharing in the app). We'll also have to update the Clay
sidebar to link to this app from every game on Kik.

Top 40 on Kik translates to ~300,000 uniques / month

Push tokens for all users, no email yet (next stage of app)
