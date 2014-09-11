z = require 'zorium'

RatingsWidget = require './stars'
vars = require '../../stylus/vars.json'
Experiment = require '../models/experiment'

module.exports = class GameBox
  constructor: (@game) ->
    @RatingsWidget = new RatingsWidget stars: @game.rating

  loadGame: =>
    ga('send', 'event', 'game_box', 'click', @game.key)
    Experiment.convert 'game_box_click'
    z.route @game.getRoute()
    kik.picker?('http:' + @game.getSubdomainUrl(), {}, -> null)

  render: ->
    z '.game-box', {onclick: @loadGame}, [
      z 'img',
        src: @game.icon128Url
        width: vars.$marketplaceGameIconWidth,
        height: vars.$marketplaceGameIconHeight
      z '.game-box-info', [
        z 'h3', @game.name
        @RatingsWidget.render()
      ]
    ]
