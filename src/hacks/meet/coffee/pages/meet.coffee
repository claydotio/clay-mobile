z = require 'zorium'

Navigation = require '../models/navigation'
# for some reason this fails if we use a var instead of string ../../../coffee
Header = require '../../../../coffee/components/header'
GameResults = require '../../../../coffee/components/game_results'

Menu = require '../components/menu'
Meet = require '../components/meet'

module.exports = class MeetPage
  constructor: ->
    Navigation.setPage 'meet'

    @Header = new Header()
    @GameResults = new GameResults()
    @Menu = new Menu()
    @Meet = new Meet()

  render: =>
    z 'div', [
      z 'div', @Header.render()
      z 'div', @Menu.render()
      @Meet.render()
    ]
