z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

Game = require '../../models/game'
WindowHeightDir = require '../../directives/window_height'
# FIXME: remove, replace with beforeUnload functionality of components
LogEngagedPlayDir = require '../../directives/log_engaged_play'
SDKDir = require '../../directives/sdk'
Drawer = require '../drawer'
Spinner = require '../spinner'
UrlService = require '../../services/url'
Modal = require '../../models/modal'
GameShare = require '../game_share'

styles = require './index.styl'

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    styles.use()

    @WindowHeightDir = new WindowHeightDir()
    @SDKDir = new SDKDir()

    @Spinner = new Spinner()

    @isLoading = true
    @gameKey = z.prop gameKey

    @game = z.prop Game.findOne(key: gameKey)
    @game.then =>
      @isLoading = false

    # FIXME: remove, replace with beforeUnload functionality of components
    @LogEngagedPlayDir = @game.then (game) ->
      directive = new LogEngagedPlayDir(game)
      z.redraw()
      return directive

    @Drawer = z.prop @game.then (game) ->
      new Drawer {game}

    @onFirstRender = _.once =>
      @showShareModalPromise = Game.incrementPlayCount(gameKey)
      .then (playCount) =>
        shouldShowModal = playCount is 3
        if shouldShowModal
          @showShareModal()

  showShareModal: =>
    @game.then (game) ->
      Modal.openComponent(
        component: new GameShare({game})
      )

  # if already on marketplace, keep them there with root route, otherwise
  # hard redirect to marketplace
  redirectToMarketplace: ->
    if UrlService.isRootPath()
      z.route '/'
    else
      window.location.href = UrlService.getMarketplaceBase()

  render: =>
    @onFirstRender()

    if @isLoading
      z '.game-player-missing',
        @Spinner.render()
        z 'button.button-ghost', {onclick: @redirectToMarketplace},
          'Return to Clay.io'
    else if @game()?.gameUrl
      # FIXME: remove, replace with beforeUnload functionality of components
      z 'div.game-player', {config: @LogEngagedPlayDir()?.config},
        z 'iframe' +
          '[webkitallowfullscreen][mozallowfullscreen][allowfullscreen]' +
          '[scrolling=no]',
              src: @game().gameUrl

              config: =>
                # This is necessary due a resizing issue on some devices
                @WindowHeightDir.config.apply @WindowHeightDir, arguments

                # Bind listeners for SDK Clay.client() calls
                @SDKDir.config.apply @SDKDir, arguments

        @Drawer()?.render()
    else
      z '.game-player-missing',
        z 'div', 'Game Not Found'
        z 'button.button-ghost', {onclick: @redirectToMarketplace},
          'Return to Clay.io'
