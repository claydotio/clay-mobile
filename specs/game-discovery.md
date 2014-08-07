## Clay Mobile: Game Discovery

### OBJECTIVE

  1. **Get users playing games they might be interested in**
    - Metrics: Returning visitors, Average game session length, Game bounce rate, Number of games played per session
  2. **Be the central point of discovery for games on Kik**
    - Metrics: Returning visitors, Average game session length, Game bounce rate, Number of games played per session
  3. **Create a strong base for the remainder of our cornerstone app**
    - Metrics: Page load time

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - **Returning visitors**
    - TBD (We'll need a good way to track % of users that return - right now we can only do % of new vs returning)
  - **Average game session length**
    - \> 3:00
  - **Game bounce rate**
    - < 40%
  - **Number of games played per session**
    - TBD (we'll need to find a good way to track this in GA)
  - ** Monthly Uniques **
    - 500,000 (top 30 on Kik)
  - **Page load time**
    - Performance meeting all [performance requirements](#performance-requirements)

### FEATURES

  1. Populated list of games
  2. Ability to access a game by clicking on the promotional image / game tile
  3. Ability to view more games through scrolling (infinite pagination)
  4. Ability to filter games by category
  5. Ability to sort by popularity (default) and date
  6. Push tokens stored (Kik)

### FEATURES IN-DEPTH

  1. Populated list of games
    - **Why?** Give users an immediate choice/entry point to eye-catching games
    - **Initial Games**  Defaults to 15 most-popular games, where most-popular takes into account:
      price (favoring free), rating, plays yesterday, staff rating, votes, featured status, last update and add time
    - **Smart Game Loading**
      - Detect bounce rate for games on different devices, flag a game as not working for a device subset and don't show for consumers on that device

  2. Ability to access a game by tapping on the promotional image / game tile
    - **Why?** To get users in the game ASAP (no in-between details page)
    - Tapping on the game will open it inside a modal window on Kik (on other platforms we'll redirect, etc...)

  3. Ability to view more games through scrolling
    - **Why?** To give users a larger selection of games
    - Infinite scrolling or pagination
      - Rough implementation at first - we can worry about memory usage later (eg Facebook, LinkedIn HTML5 experiences)

  4. Ability to filter games by category
    - **Why?** To help users find the right game for them / their current mood
    - Categories: Action, Multiplayer, Shooter, Adventure, RPG, Sports, Racing, Strategy, Defense, Puzzle, Arcade, Educational

  5. Ability to sort by popularity (default) and date
    - **Why?** The main aspect here is the option to sort by date - this lets users find new games
    - Date vs Popularity toggle
  6. Push tokens stored (Kik)
    - **Why?** Retention
    - Store every visitors push token and send push notifications every 3rd day (we'll bump up the frequency when the app is more complete)

### BACKEND

  - For now, grab data from MySQL since entire developer dashboard is tied to it
  - Separate node.js server for this app

### USERS

  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS

Open App -> Game List -> Choose Game
Open App -> Game List -> Choose categor(ies) -> Choose game
Open App -> Game List -> Change sorting -> Choose game

### WIREFRAMES

![Wireframe](/../master/specs/resources/kik-modal.png?raw=true)

### PREPARING FOR NEW PLATFORMS

While we're initially building this for Kik, we need to keep in mind it will soon be followed by other platforms.

#### Marketplace -> Game Open Flow

On Kik we have the option to either open the game in a modal window within the Clay 'app' (see figure 1), OR we
can open a new page that takes up the whole window. Both add the game as a favorite to the sidebar.

My initial feeling is the modal option will be better for us because it helps the marketplace app retain better
The downside is it could cause less engagement in the games themselves. This is something we should test.

**Figure 1 (this is a chat modal over an app. The browser modal is similar - just different content)**
![Figure 1](/../master/specs/resources/kik-modal.png?raw=true)

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
  - Initial load should be absolutely as quick as possible (main reason is Kik has a loading splash until load event)
  - We want all game images to be loaded within another 3 seconds on 3G.

WebPageTest stats for other sites Motorola G Chrome
  - Indeed ~4s
  - Threadless ~15s
  - CNN ~15s
  - ESPN ~10s

For this stage we're looking at 20k DAU and likely no more than 200-250 concurrent (in-line with top 40 metric)

### A/B TESTS

#### Removing Scrolling

  - **Hypothesis:** removing scrolling will result in increased game engagement
    - Less options forces the user to select one the games we suggest (higher quality / potentially more relevant)
    - No scrolling will be easier to maintain
  - **Primary metrics**: Bounce rate, session length
  - **Potential problems:**
    - If our recommended/popular game algorithm is bad, we should see the opposite effect (bounce rate increasing)

#### Removing Categories

  - **Hypothesis:** removing categories will cause no effect across all metrics
    - No categories will be easier to maintain
    - When we add search, categories could be implemented within the search (eg search for category)
  - **Primary metrics:** Returning visitors, bounce rate of games, game session length, number of games played per session, monthly uniques

#### REMOVING SORTING

  - **Hypothesis:** removing the sort toggle will result in increased game engagement
    - Sorting by date will theoretically display more poor quality games, decreasing engagement
    - No sorting will be easier to maintain
  - **Primary metrics:** Bounce rate, session length

#### DIFFERENT ALGORITHMS

  - **Hypothesis:** there is an optimal popularity algorithm out there that we can find through testing multiple
    - We will come up with an intial algorithm, then tweak the weights to test various algorithms
  - **Primary metrics:** Bounce rate, session length

#### GAME DETAILS PAGE

Note: this is for phase 2 of development (external game sharing implementation)
  - **Hypothesis** sending the user to a game details page before the game itself will cause an increase in external game shares without affecting the number of games played per sesion
  - **Primary metrics:** Game shares (external), Number of games played per session
