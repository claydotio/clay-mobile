z = require 'zorium'

GameFilter = require '../models/game_filter'
Header = require '../components/header'
GameMenu = require '../components/game_menu'
GameResults = require '../components/game_results'

module.exports = class GamesPage
  constructor: (params) ->
    GameFilter.setFilter params('filter') or 'top'

    @Header = new Header()
    @GameMenu = new GameMenu()
    @GameResults = new GameResults()

  render: =>
    (new (require '../components/splash')()).render()
    ###
    z 'div', [
      z 'div', @Header.render()
      z 'div', @GameMenu.render()
      z 'div', @GameResults.render()
    ]
    ###
