z = require 'zorium'

RatingsWidget = require './ratings'

module.exports = class GameBox
  constructor: (game) ->
    @game = game
    @ratings = new RatingsWidget(stars: game.rating)

  render: ->
    z '.game-box', [
      z 'img', src: @game.icon128Url
      z '.game-box-info', [
        z 'h3.title', @game.name
        z 'div', @ratings.render()
      ]
    ]
