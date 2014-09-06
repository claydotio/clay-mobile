z = require 'zorium'

RatingsWidget = require './stars'
vars = require '../../stylus/vars.json'
Experiment = require '../models/experiment'

module.exports = class GameBox
  constructor: (game) ->
    @game = game
    @ratings = new RatingsWidget(stars: game.rating)

  loadGame: =>
    ga('send', 'event', 'game_box', 'click', @game.key)
    Experiment.convert 'game_box_click'
    gameUrl = 'http://' + @game.key + '.' + window.location.host
    z.route '/game/' + @game.key
    kik.picker?(gameUrl, {}, -> null)

  render: ->
    z '.game-box', {onclick: @loadGame}, [
      z 'img',
        src: @game.icon128Url
        width: vars.$marketplaceGameIconWidth,
        height: vars.$marketplaceGameIconHeight
      z '.game-box-info', [
        z 'h3', @game.name
        z 'div', @ratings.render()
      ]
    ]
