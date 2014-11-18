z = require 'zorium'

GameFilter = require '../../models/game_filter'
Header = require '../../components/header'
GameMenu = require '../../components/game_menu'
GameResults = require '../../components/game_results'

module.exports = class GamesPage
  constructor: ({filter} = {}) ->
    GameFilter.setFilter filter or 'top'

    @Header = new Header()
    @GameMenu = new GameMenu()
    @GameResults = new GameResults()

  render: =>
    z 'div', [
      z 'div', @Header
      z 'div', @GameMenu
      z 'div', @GameResults
    ]
