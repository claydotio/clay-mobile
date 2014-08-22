z = require 'zorium'

module.exports = class GamesPage
  constructor: (params) ->
    GameFilter = require '../models/game_filter'
    GameFilter.setFilter params('filter') or 'top'

    @GameMenu = new (require '../components/game_menu')()
    @Header = new (require '../components/header')()
    @GameResults = new (require '../components/game_results')()

  render: =>
    z 'div', [
      z 'div', @Header.render()
      z 'div', @GameMenu.render()
      z 'div', @GameResults.render()
    ]
