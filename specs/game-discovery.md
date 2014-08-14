## Clay Mobile: Game Discovery

### OBJECTIVE

  1. **Get users playing games they might be interested in**
    - Metrics: Average game session length, Number of games played per session
  3. **Be the central point of discovery for games on Kik**
    - Metrics: Returning Users, DAU

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
  - **Returning visitors (D1/D7/D30)**
    - TBD
  - **Average game session length**
    - \> 3:00
  - **Number of games played per session**
    - TBD (we'll need to find a good way to track this in GA)
  - ** DAU **
    - 15,000 (top 30 on Kik)

### FEATURES

  1. Populated list of games
    - **Why?** Give users an immediate choice/entry point to eye-catching games
    - **Initial Games**  Defaults to most-popular games, where most-popular takes into account:
      price (favoring free), rating, plays yesterday, staff rating, votes, featured status, last update and add time
    - **Smart Game Loading**
      - Detect bounce rate for games on different devices, flag a game as not working for a device subset and don't show for consumers on that device
  2. Ability to access a game immediately
    - **Why?** To get users in the game ASAP (no in-between details page)
  3. Ability to view more games
    - **Why?** To give users a larger selection of games
  4. Ability to sort by popularity (default) and new popularity
    - **Why?** lets users find new games
  5. Push Notifications
    - **Why?** To bring users back
    - send push notifications at some daily interval (e.g. every 3rd day)

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

(Cristian, feel free to scrap this)
![Wireframe](/../master/specs/resources/game-discovery.png?raw=true)

### NOTES

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

#### Add Categories

  - **Hypothesis:** adding categories will cause an increase in games played per session and game engagement
    - More targeted games for the player / their current mood
  - **Primary metrics:** game session length, number of games played per session

#### Thumb up / Thumb down

  - **Hypothesis:** A thumbs rating system would lead to more games played per session and more ratings per user
    - The primary case for this would be users like to see a green/red Youtube style bar (or some other UI) to indicate good games
  - **Primary metrics:** number of games played per session, ratings per user
