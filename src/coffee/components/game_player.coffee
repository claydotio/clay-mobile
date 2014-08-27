z = require 'zorium'
_ = require 'lodash'

Game = require '../models/game'

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    @gameKey = z.prop gameKey

    z.startComputation
    @game = z.prop Game.all('games').findOne(key: gameKey)
    @game.then z.endCompuation

  render: =>
    z 'div.game-player', [
      if @game()?.gameUrl
      then z 'iframe', {src: @game().gameUrl}
      else z '.game-player-missing', 'Game Not Found'
    ]
