## Clay Mobile: Game Discovery

### OBJECTIVE
  1. Get users playing games they might be interested in
  2. Be the central point of discovery for game on Kik
  3. Create a strong base for the remainder of our cornerstone app

### FEATURES
  1. Populated list of games
  2. Ability to access a game by clicking on the promotional image
  3. Ability to view more games through scrolling (infinite pagination)
  4. Ability to filter games by category
  5. Ability to sort by popularity (default) and date

### FEATURES IN-DEPTH
  1. Populated list of games
    - **Why?** Give users an immediate choice/entry point to eye-catching games
    - **Initial Games**  Defaults to 15 most-popular games, where most-popular takes into account:
      price (favoring free), rating, plays yesterday, staff rating, votes, featured status, last update and add time
      ```
    - **Smart Game Loading**
      - Detect bounce rate for games on different devices, flag a game as not working for a device subset and don't show for consumers on that device

  2. Ability to access a game by tapping on the promotional image
    - **Why?** To get users in the game ASAP (no in-between details page)
    - Tapping on the game will open it inside a modal window on Kik (on other platforms we'll redirect, etc...)

  3. Ability to view more games through scrolling
    - **Why?** To give users a larger selection of games
    - Infinite scrolling
      - Rough implementation at first - we can worry about memory usage later (eg Facebook, LinkedIn HTML5 experiences)

  4. Ability to filter games by category
    - **Why?** To help users find the right game for them / their current mood
    - Full list of categories isn't shown at first, just "Categories" button.
    - Tapping on this button expands the list of categories:  
      - Action, Multiplayer, Shooter, Adventure, RPG, Sports, Racing, Strategy, Defense, Puzzle, Arcade, Educational

  5. Ability to sort by popularity (default) and date
    - **Why?** The main aspect here is the option to sort by date - this lets users find new games
    - For now we can have a toggle beneath the categories.
    - Cristian can work on a smarter way to display this

### BACKEND
  - For now, grab data from MySQL since entire developer dashboard is tied to it
  - No other database for this stage since the primary use is just to display games
  - Separate node.js server for this app
  - Horizontally scalable

### USERS
  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

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
  - Kik - Game modal (Kik API call)
  - Google Play - Webview (potentially APK request - but that will likely be from within the game)
  - Amazon - Webview
  - iOS - Webview, but it may need to be a webview that looks more like a traditional browser (eg URL bar like Kik)
  - Facebook - Facebook webview OR Safari if it makes sense for better retention (and we're technologically able to do it)
  - Firefox OS - I think they have an API to save to device

#### Resolution
  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS
  - First view < 5s load time [http://www.webpagetest.org](WebPageTest) (this does not include all initial images).
  - Kik doesn't hide their "Loading" screen until the load event, so we want that to be as quick as possible, then load
  game images
  - We want all game images to be loaded within another 3 seconds on 3G.

WebPageTest stats for other sites Motorola G Chrome
  - Indeed ~4s
  - Threadless ~15s
  - CNN ~15s
  - ESPN ~10s

For this stage we're looking at 20k DAU and likely no more than 200-250 concurrent (in-line with top 40 metric)

### METRICS TO TRACK
It's difficult to define what we want these metrics to be without the app already existing. We can use these to
A/B test and improve phase 1 of the app in those areas.

In order of importance:
  - Repeat visitors
  - Average game session length (lets us know if our popular games/eventually recommended games are good picks)
  - Game bounce rate (same reason as above)
  - Number of games played per session

### A/B TESTS
We'll run tests as follows:

#### Test #1
Test combinations of the following features:
  - Feature 3. Ability to view more games through scrolling (infinite pagination)
  - Feature 4. Ability to filter games by category
  - Feature 5. Ability to sort by popularity (default) and date

Tests consist of
  - `3`, `3, 4`, `3, 4, 5`, `4`, `4, 5`, `5`
  - Conversion primary metrics
    - Repeat visitors, bounce rate of games, game session length, number of games played per session

#### Test #2 (once Test #1 is compelete)
  - Feature 1. Populated list of games
    - A-?: Supply different algorithms for which games to display
    - Conversion primary metrics
      - Repeat visitors, bounce rate of games, game session length, number of games played per session

#### Test #3 (after we implement external game sharing)
  - Feature 2. Ability to access a game by tapping on the promotional image
    - A: Load game after tapping on promotional image
    - B: Load game info page after tapping on promotional image
    - Conversion primary metrics
      - Repeat visitors, hares per session, bounce rate of games, game session length, number of games played per session


### WHAT SUCCESS LOOKS LIKE
We want this version of the app to consistently stay in the **top 30** on Kik. To do so, we'll have to drive a
good bit of traffic to it (since there's no inherent sharing in the app). We'll also have to update the Clay
sidebar to link to this app from every game on Kik.

Top 30 on Kik translates to ~500,000 uniques / month

Push tokens for all users, no email yet (next stage of app)
