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
      if @game()?.gameUrl
      then z 'iframe' +
                '[webkitallowfullscreen][mozallowfullscreen][allowfullscreen]' +
                '[scrolling=no]',
              src: @game().gameUrl
              style: 'height: ' + window.innerHeight + 'px'
      else
        z '.game-player-missing', 'Game Not Found'
    ]
