z = require 'zorium'

RatingsWidget = require './stars'

module.exports = class GameBox
  constructor: (game) ->
    @game = game
    @ratings = new RatingsWidget(stars: game.rating)

  loadGame: =>
    gameUrl = 'http://' + @game.key + '.' + window.location.host
    z.route '/game/' + @game.key
    kik.picker?(gameUrl, {}, -> null)

  render: ->
    z '.game-box', {onclick: @loadGame}, [
      z 'img', src: @game.icon128Url
      z '.game-box-info', [
        z 'h3', @game.name
        z 'div', @ratings.render()
      ]
    ]
