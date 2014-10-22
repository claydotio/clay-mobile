z = require 'zorium'

Navigation = require '../models/navigation'
Header = require '../../../../coffee/components/header'
Menu = require '../components/menu'
GameResults = require '../../../../coffee/components/game_results'

module.exports = class GamesPage
  constructor: ->
    Navigation.setPage 'games'

    @Header = new Header()
    @Menu = new Menu()
    @GameResults = new GameResults()

  render: =>
    z 'div', [
      z 'div', @Header.render()
      z 'div', @Menu.render()
      z 'div', @GameResults.render()
    ]
