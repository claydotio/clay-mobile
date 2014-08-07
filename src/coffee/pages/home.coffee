z = require 'zorium'

NavView = new (require '../views/nav')()
HeaderView = new (require '../views/header')()
GameResultsView = new (require '../views/game_results')()

module.exports = class HomePage
  view: ->
    z 'div', [
      z 'div', HeaderView.render()
      z 'div', NavView.render()
      z 'div', GameResultsView.render()
    ]
  controller: ->
    null
