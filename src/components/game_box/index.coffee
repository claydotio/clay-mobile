z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

Stars = require '../stars'
User = require '../../models/user'
UrlService = require '../../services/url'
GameLockService = require '../../services/game_lock'
ShareService = require '../../services/share'

styles = require './index.styl'

DEFAULT_GAME_BOX_ICON_SIZE = 128
MARKETPLACE_GAME_ID = '1'

module.exports = class GameBox
  constructor: ({game, iconSize}) ->
    styles.use()

    iconSize ?= DEFAULT_GAME_BOX_ICON_SIZE
    @state = z.state
      $stars: new Stars stars: game.rating
      gameSubdomainUrl: UrlService.getGameSubdomain {game}
      isLocked: z.observe GameLockService.isLocked(game)
      game: game
      iconSize: iconSize

    @state.isLocked.then (isLocked) ->
      if isLocked
        ga? 'send', 'event', 'game_box', 'lock_view', game.key

  loadGame: (e) =>
    e?.preventDefault()

    {game, isLocked} = @state()

    if isLocked
      ga? 'send', 'event', 'game_box', 'lock_click', game.key

      ShareService.any
        text: 'Come check out Clay.io!'
        gameId: MARKETPLACE_GAME_ID
      .catch log.trace

      # Kik share modal latency compensation
      setTimeout =>
        @state.set isLocked: false

        GameLockService.unlock game
        .catch log.trace
      , 500

      return

    ga? 'send', 'event', 'game_box', 'click', game.key
    User.convertExperiment('game_box_click').catch log.trace
    z.router.go UrlService.getGameRoute {game}
    httpSubDomainUrl = UrlService.getGameSubdomain({game, protocol: 'http'})
    kik?.picker?(httpSubDomainUrl, {}, -> null)

  render: ({$stars, gameSubdomainUrl, isLocked, game, iconSize}) =>
    z "a.z-game-box[href=#{gameSubdomainUrl}]",
      onclick: @loadGame
      style:
        width: "#{iconSize}px",
      z 'img',
        src: game.iconImage?.versions[0].url or game.icon128Url
        width: iconSize
        height: iconSize
      z '.info',
        z 'h3', game.name
        $stars
      if isLocked
        z '.lock',
          z 'i.icon.icon-locked'
          z 'div', 'share to unlock'
