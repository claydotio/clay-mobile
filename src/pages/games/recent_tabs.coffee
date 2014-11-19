z = require 'zorium'

GameFilter = require '../../models/game_filter'
User = require '../../models/user'
Header = require '../../components/header/orange'
GameMenu = require '../../components/game_menu/recent_popular'
GooglePlayAd = require '../../components/google_play_ad'
RecentGames = require '../../components/recent_games/large_inset'
GameResults = require '../../components/game_results/popular'
ModalViewer = require '../../components/modal_viewer'

module.exports = class GamesPage
  constructor: ({filter} = {}) ->
    User.getMe().then (user) =>
      @hasRecentGames = user.links.recentGames

      filter = if @hasRecentGames \
               then filter or 'recent'
               else 'top'
      GameFilter.setFilter filter

      @Games = if filter is 'recent' \
               then new RecentGames()
               else new GameResults()
      @GameMenu = new GameMenu()

      z.redraw()

    @Header = new Header()
    @GooglePlayAd = new GooglePlayAd()
    @ModalViewer = new ModalViewer()

  render: =>
    z 'div', [
      z 'div', @Header
      z 'div', @GooglePlayAd
      if @hasRecentGames then z 'div', @GameMenu
      z 'div', @Games
      @ModalViewer
    ]
