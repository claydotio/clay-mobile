## Clay Mobile: Game Discovery

### OBJECTIVE

  1. **Get users playing games they might be interested in**
    - Metrics: Average game session length, Number of games played per session
  2. **Be the central point of discovery for games on Kik**
    - Metrics: DAU from Kik

### FEATURES

  1. Populated list of games
    - **Why?** Give users an immediate choice/entry point to eye-catching games
    - **Initial Games**  Defaults to most-popular games, where most-popular takes into account:
      price (favoring free), rating, plays yesterday, staff rating, votes, featured status, last update and add time
    - **Smart Game Loading**
      - Detect bounce rate for games on different devices, flag a game as not working for a device subset and don't show for consumers on that device
  1. Ability to access a game immediately
    - **Why?** To get users in the game ASAP (no in-between details page)
  1. Ability to view more games
    - **Why?** To give users a larger selection of games
  1. Ability to sort by popularity (default) and new popularity
    - **Why?** lets users find new games
  1. Push Notifications
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

![Wireframe](/../master/specs/resources/kik-modal.png?raw=true)

### Notes

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

  - **Hypothesis:** removing categories will cause no effect across all metrics
    - No categories will be easier to maintain
    - When we add search, categories could be implemented within the search (eg search for category)
  - **Primary metrics:** Returning visitors, bounce rate of games, game session length, number of games played per session, monthly uniques
