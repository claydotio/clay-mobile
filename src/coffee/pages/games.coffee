z = require 'zorium'

module.exports = class GamesPage
  constructor: (params) ->
    GameFilter = require '../models/game_filter'
    GameFilter.setFilter params('filter') or 'top'

    @Nav = new (require '../components/nav')()
    @Header = new (require '../components/header')()
    @GameResults = new (require '../components/game_results')()

  render: =>
    z 'div', [
      z 'div', @Header.render()
      z 'div', @Nav.render()
      z 'div', @GameResults.render()
    ]
