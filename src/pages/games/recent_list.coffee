z = require 'zorium'

Header = require '../../components/header/orange_shadow'
RecentGames = require '../../components/recent_games/list'
GameResults = require '../../components/game_results/popular_small_top'

module.exports = class GamesPage
  constructor: (params) ->
    @Header = new Header()
    @RecentGames = new RecentGames()
    @PopularGames = new GameResults()

  render: =>
    z 'div', [
      z 'div', @Header.render()
      z 'div', @RecentGames.render()
      z 'div', @PopularGames.render()
    ]
