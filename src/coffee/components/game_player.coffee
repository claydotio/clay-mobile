z = require 'zorium'
_ = require 'lodash'

Game = require '../models/game'

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    @gameKey = z.prop gameKey

    @game = z.prop Game.all('games').findOne(key: gameKey)
    @game.then z.redraw

  render: =>
    z 'div.game-player', [
      @game() and z 'iframe', {src: @game()?.gameUrl}
    ]
