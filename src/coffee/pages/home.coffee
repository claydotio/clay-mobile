z = require 'zorium'

module.exports = class HomePage
  constructor: ->
    @Nav = new (require '../components/nav')()
    @Header = new (require '../components/header')()
    @GameResults = new (require '../components/game_results')()

  view: =>
    z 'div', [
      z 'div', @Header.render()
      z 'div', @Nav.render()
      z 'div', @GameResults.render()
    ]
  controller: -> null
