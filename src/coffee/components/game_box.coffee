z = require 'zorium'

RatingsWidget = require './ratings'

module.exports = class GameBox
  constructor: (game) ->
    @game = game
    @ratings = new RatingsWidget(stars: 4)

  render: ->
    z '.game-box', [
      z 'img', src: @game.url
      z '.game-box-info', [
        z 'h3.title', @game.title
        z '.snippet', 'snippet'
        z 'div', @ratings.render()
      ]
    ]
