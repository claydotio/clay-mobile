z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'

Game = require '../../models/game'
Drawer = require '../drawer'
Spinner = require '../spinner'
UrlService = require '../../services/url'
KikService  = require '../../services/kik'
Modal = require '../../models/modal'
GameShare = require '../game_share'
User = require '../../models/user'

styles = require './index.styl'

ENGAGED_PLAY_TIME = 60000 # 1 min

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    styles.use()

    @Spinner = new Spinner()

    @isLoading = true
    @height = window.innerHeight + 'px'
    @width = window.innerWidth + 'px'
    @gameKey = gameKey
    @game = null
    @Drawer = null

    gamePromise = Game.findOne(key: gameKey)
    .then (game) =>
      @game = game
      @isLoading = false
      @Drawer = new Drawer {game}

      z.redraw()
      return game

    @onFirstRender = _.once =>
      @showShareModalPromise = Promise.all [
        Game.incrementPlayCount(gameKey)
        gamePromise
      ]
      .then ([playCount, game]) =>
        KikService.isFromPush().then (isFromPush) ->
          unless isFromPush
            ga? 'send', 'event', 'game_wo_push', 'game_play', game.key
        ga? 'send', 'event', 'game', 'game_play', game.key
        shouldShowModal = playCount is 3
        if shouldShowModal
          @showShareModal(game)

  onBeforeUnmount: =>
    window.clearTimeout @engagedPlayTimeout
    window.removeEventListener 'resize', @resize

  onMount: ($el) =>
    @$el = $el

    window.addEventListener 'resize', @resize
    @resize()

    @engagedPlayTimeout = window.setTimeout @logEngagedPlay, ENGAGED_PLAY_TIME

    User.convertExperiment('game_play').catch log.trace

  resize: =>
    @height = window.innerHeight + 'px'
    @width = window.innerWidth + 'px'
    z.redraw()

  logEngagedPlay: =>
    User.convertExperiment('engaged_play').catch log.trace
    KikService.isFromPush().then (isFromPush) =>
      unless isFromPush
        ga? 'send', 'event', 'game_wo_push', 'engaged_play', @game.key
    ga? 'send', 'event', 'game', 'engaged_play', @game.key
    User.addRecentGame(@game.id).catch log.trace

  showShareModal: (game) ->
    Modal.openComponent(
      component: new GameShare({game})
    )

  # if already on marketplace, keep them there with root route, otherwise
  # hard redirect to marketplace
  redirectToMarketplace: ->
    if UrlService.isRootPath()
      z.router.go '/'
    else
      window.location.href = UrlService.getMarketplaceBase()

  render: =>
    @onFirstRender()

    if @isLoading
      z '.z-game-player-missing',
        @Spinner
        z 'button.button-ghost', {onclick: @redirectToMarketplace},
          'Return to Clay.io'
    else if @game?.gameUrl
      z 'div.z-game-player',
        style:
          height: @height
        @SDK
        z 'iframe' +
          '[webkitallowfullscreen][mozallowfullscreen][allowfullscreen]' +
          '[scrolling=no]',
              style:
                width: @width
                height: @height
              src: @game?.gameUrl
        @Drawer
    else
      z '.z-game-player-missing',
        z 'div', 'Game Not Found'
        z 'button.button-ghost', {onclick: @redirectToMarketplace},
          'Return to Clay.io'
