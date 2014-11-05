z = require 'zorium'

GameFilter = require '../../models/game_filter'
User = require '../../models/user'
Header = require '../../components/header/orange'
GameMenu = require '../../components/game_menu/recent_popular'
RecentGames = require '../../components/recent_games/large_inset'
GameResults = require '../../components/game_results/popular'

module.exports = class GamesPage
  constructor: (params) ->
    # FIXME: this prevents a white flash on game menu, but we don't want to use
    # z.startComputation...
    z.startComputation()
    User.getMe().then (user) =>
      @hasRecentGames = user.links.recentGames

      filter = if @hasRecentGames \
               then params('filter') or 'recent'
               else 'top'
      GameFilter.setFilter filter

      @Games = if filter is 'recent' \
               then new RecentGames()
               else new GameResults()
      @GameMenu = new GameMenu()

      z.redraw()
      # FIXME don't do this (and above one)
      z.endComputation()

    @Header = new Header()


  render: =>
    z 'div', [
      z 'div', @Header.render()
      if @hasRecentGames then z 'div', @GameMenu?.render()
      z 'div', @Games?.render()
    ]
