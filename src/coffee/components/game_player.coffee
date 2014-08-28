z = require 'zorium'
_ = require 'lodash'

Game = require '../models/game'
WindowHeightDir = require '../directives/window_height'

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    @windowHeightDir = new WindowHeightDir()
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

              # This is necessary due a resizing issue on some devices
              config: @windowHeightDir.config
      else
        z '.game-player-missing', 'Game Not Found'
    ]
