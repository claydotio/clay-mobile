z = require 'zorium'
_ = require 'lodash'
log = require 'loglevel'
Q = require 'q'

Game = require '../models/game'
WindowHeightDir = require '../directives/window_height'
Drawer = require '../components/drawer'

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    @WindowHeightDir = new WindowHeightDir()
    @gameKey = z.prop gameKey

    @game = z.prop Game.all('games').findOne(key: gameKey)
    @Drawer = z.prop @game.then (game) ->
      new Drawer {game}

    # use Q for finally and catch
    # TODO: (Austin) remove Q dependency when Zorium uses Q
    Q.when @Drawer
    .finally z.redraw
    .catch log.trace

  render: =>
    if @game()?.gameUrl
      z 'div.game-player',
        z 'iframe' +
          '[webkitallowfullscreen][mozallowfullscreen][allowfullscreen]' +
          '[scrolling=no]',
              src: @game().gameUrl

              # This is necessary due a resizing issue on some devices
              config: @WindowHeightDir.config
        @Drawer()?.render()
    else
      z '.game-player-missing',
        z 'div', 'Game Not Found'
        z 'button.button-ghost',
          onclick: -> window.location.href = '//' + window.location.host,
          'Return to Clay.io'
