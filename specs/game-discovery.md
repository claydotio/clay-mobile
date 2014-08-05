Clay Mobile: Game Discovery
---------------------------

### OBJECTIVE
1. Get users playing games they might be interested in
2. Be the central point of discovery for game on Kik
3. Create a strong base for the remainder of our cornerstone app

### FEATURES
1. List of games
2. Ability to access a game by clicking on the promotional image
3. Ability to view more games through scrolling (infinite pagination)
4. Ability to filter games by category
5. Ability to sort by rating and date

### FEATURES IN-DEPTH
1. List of games
  * **Initial Games**  Defaults to 15 most-popular games, where most-popular takes into account:
    price (favoring free), rating, plays yesterday, staff rating, votes, featured status, last update and add time
    ```
  * **Smart Game Loading**
    * Detect bounce rate for games on different devices, flag a game as not working for a device subset and don't show for consumers on that device

2. Ability to access a game by clicking on the promotional image
TODO: Redirect to marketplace, open game modal

3. Ability to view more games through scrolling
  * Infinite scrolling
    * Rough implementation at first - we can worry about memory usage later (eg Facebook, LinkedIn HTML5 experiences)

4. Ability to filter games by category
  * Full list of categories isn't shown at first, just "Categories" button.
  * Tapping on this button expands the list of categories:  
    * Action, Multiplayer, Shooter, Adventure, RPG, Sports, Racing, Strategy, Defense, Puzzle, Arcade, Educational

5. Ability to sort by rating and date
  * For now we can have a toggle beneath the categories.
  * Cristian can work on a smarter way to display this

### BACKEND
* For now, grab data from MySQL since entire developer dashboard is tied to it
* No other database for this stage since the primary use is just to display games
* Separate node.js server for this app
* Horizontally scalable

### USERS
1. Kik Users
  * Age: 52% 13-18, 23% 19-25, 25% 26+
  * Gender: 51% male, 49% female
  * Location: 60% North America
  * Platform: 52% iOS, 45% Android
  * Likes: Flirting, Meeting new people

### USER FLOWS
Open App -> Game List -> Choose Game
                      |
                      -> Choose categor(ies) -> Choose game
                      |
                      -> Change sorting -> Choose game

### WIREFRAMES
game-discovery.ep

### PREPARING FOR NEW PLATFORMS
While we're initially building this for Kik, we need to keep in mind it will soon be followed by other platforms.

#### Marketplace -> Game Open Flow
On Kik we have the option to either open the game in a modal window within the Clay 'app' (see figure 1), OR we
can open a new page that takes up the whole window. Both add the game as a favorite to the sidebar.

My initial feeling is the modal option will be better for us because it helps the marketplace app retain better
The downside is it could cause less engagement in the games themselves. This is something we should test.

**Figure 1 (this is a chat modal over an app. The browser modal is similar - just different content)**
<img src="/../master/specs/resources/kik-modal.png?raw=true" alt="Figure 1" style="width: 250px">

When branching out to other platforms, we'll want to consider the best way to open an app/game in each of those.
For now, we need to make sure the 'game opening method' is interchangable by platform.

Eg.
* Kik - Game modal (Kik API call)
* Google Play - Webview (potentially APK request - but that will likely be from within the game)
* Amazon - Webview
* iOS - Webview, but it may need to be a webview that looks more like a traditional browser (eg URL bar like Kik)
* Facebook - Facebook webview OR Safari if it makes sense for better retention (and we're technologically able to do it)
* Firefox OS - I think they have an API to save to device

#### Resolution
* Needs to be responsive, but we'll lock it in portrait for now
* Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
* First view < 5s load time [http://www.webpagetest.org](WebPageTest) (this does not include all initial images).
* Kik doesn't hide their "Loading" screen until the load event, so we want that to be as quick as possible, then load
game images
* We want all game images to be loaded within another 3 seconds on 3G.

WebPageTest stats for other sites Motorola G Chrome
* Indeed ~4s
* Threadless ~15s
* CNN ~15s
* ESPN ~10s

For this stage we're looking at 20k DAU and likely no more than 200-250 concurrent (in-line with top 40 metric)

### WHAT SUCCESS LOOKS LIKE
We want this version of the app to consistently stay in the **top 30** on Kik. To do so, we'll have to drive a
good bit of traffic to it (since there's no inherent sharing in the app). We'll also have to update the Clay
sidebar to link to this app from every game on Kik.

Top 30 on Kik translates to ~500,000 uniques / month

Push tokens for all users, no email yet (next stage of app)

#### Metrics that measure success
It's difficult to define what we want these metrics to be without the app already existing. We can use these to
A/B test and improve phase 1 of the app in those areas
* Repeat visitors
* Number of games played per session
* Total number of sessions (important for climbing to #1 spot)
* Average time spent per game (lets us know if our popular games/eventually recommended games are good picks)

All can be achieved in Google Analytics
