
## Clay Mobile: Game View

### OBJECTIVE

  1. **Push traffic to the marketplace**
    - Metrics: Marketplace views (from game page), Number of games played per session
  2. **Create an engaging experience focused on the game**
    - Metrics: Average game session length

#### SUMMARY OF METRICS

In order of importance (though all are still very important), along with success criteria:
-  - **Average game session length**
-    - \> 3:00
-  - **Number of games played per session**
-    - TBD (we'll need to find a good way to track this in GA)
-  - **DAU of Marketplace**
-    - 15,000 (top 30 on Kik)

### FEATURES

  1. Game is displayed - full screen
    - **Why?** More engaging - longer average session length
    - Scroll past URL bar on mobile
  2. Initial game load redirect (Kik only)
    - **Why?** More marketplace views, more games played per session (because of marketplace being higher up, and easier access to marketplace with modal close button)
    - All games/apps on Kik that are in our marketplace will redirect to the marketplace (for the DAU) and open the game in Kik's native modal
    - At this stage we shouldn't jump right into having all of our apps redirect to the marketplace and open in modal
      - Start with two of our lesser-apps: Hotness Factor and Pretty Bubbles

### BACKEND/TECH

  - Inside a frame you may run into some scaling issues on iOS 5 for games that use meta tag width=device-width (Construct 2 games typically have this issue)
  - API is loaded in the parent frame
    - For [swipe bar](./swipe-bar.md)
  - Games should be accessible at subdomain.clay.io (replacing old PHP implementation)

### USERS

  1. Kik Users
    - Age: 52% 13-18, 23% 19-25, 25% 26+
    - Gender: 51% male, 49% female
    - Location: 60% North America
    - Platform: 52% iOS, 45% Android
    - Likes: Flirting, Meeting new people

### USER FLOWS

  1. External source -> Game on Kik -> Redirect to Marketplace -> Game View Modal Opens
  2. Internal Cross-promotion (from another game) -> Marketplace link (not direct link to game) -> Game View Modal Opens
  3. Internal Marketplace page -> Tap on game -> Game View Modal Opens

### WIREFRAMES

N/A

### NOTES

#### Marketplace <-> Game Flow

  - Cross promotion on Kik will go do marketplace->modal flow, elsewhere it will go directly to game
  - On platforms like Android, we might want a more obvious 'return to marketplace' that's not hidden in swipe bar
  - "More games" link (back to marketplace) will behave different on each platform

#### Resolution

  - Needs to be responsive, but we'll lock it in portrait for now
  - Needs to account for retina devices with the promo images

### PERFORMANCE REQUIREMENTS

  - Swipe bar nub should be visible within 2 seconds of the game content first loading (3G)
