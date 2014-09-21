z = require 'zorium'
_ = require 'lodash'
log = require 'loglevel'
Q = require 'q'

Game = require '../models/game'
WindowHeightDir = require '../directives/window_height'
# FIXME: remove, replace with beforeUnload functionality of components
LogEngagedPlayDir = require '../directives/log_engaged_play'
Drawer = require '../components/drawer'
Spinner = require '../components/spinner'
UrlService = require '../services/url'

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    @WindowHeightDir = new WindowHeightDir()
    # FIXME: remove, replace with beforeUnload functionality of components
    @LogEngagedPlayDir = new LogEngagedPlayDir(gameKey)

    @Spinner = new Spinner()

    @isLoading = true
    @gameKey = z.prop gameKey

    @game = z.prop Game.all('games').findOne(key: gameKey)
    @game.then =>
      @isLoading = false

    @Drawer = z.prop @game.then (game) ->
      new Drawer {game}

    # use Q for finally and catch
    # TODO: (Austin) remove Q dependency when Zorium uses Q
    Q.when @Drawer
    .finally z.redraw
    .catch log.trace

  # if already on marketplace, keep them there with root route, otherwise
  # hard redirect to marketplace
  redirectToMarketplace: ->
    if UrlService.isRootPath()
      z.route '/'
    else
      window.location.href = UrlService.getMarketplaceBase()

  render: =>
    if @isLoading
      z '.game-player-missing',
        @Spinner.render()
        z 'button.button-ghost', {onclick: @redirectToMarketplace},
          'Return to Clay.io'
    else if @game()?.gameUrl
      # FIXME: remove, replace with beforeUnload functionality of components
      z 'div.game-player', {config: @LogEngagedPlayDir.config},
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
        z 'button.button-ghost', {onclick: @redirectToMarketplace},
          'Return to Clay.io'
