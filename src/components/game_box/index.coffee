z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

RatingsWidget = require '../stars'
User = require '../../models/user'
UrlService = require '../../services/url'

styles = require './index.styl'

DEFAULT_GAME_BOX_ICON_SIZE = 128

module.exports = class GameBox
  constructor: ({@game, @iconSize}) ->
    styles.use()

    @iconSize ?= DEFAULT_GAME_BOX_ICON_SIZE

    @RatingsWidget = new RatingsWidget stars: @game.rating
    @gameSubdomainUrl = UrlService.getGameSubdomain {@game}

  loadGame: (e) =>
    e?.preventDefault()

    ga? 'send', 'event', 'game_box', 'click', @game.key
    User.convertExperiment('game_box_click').catch log.trace
    z.router.go UrlService.getGameRoute {@game}
    httpSubDomainUrl = UrlService.getGameSubdomain({@game, protocol: 'http'})
    kik?.picker?(httpSubDomainUrl, {}, -> null)

  render: =>
    z "a.z-game-box[href=#{@gameSubdomainUrl}]",
      onclick: @loadGame
      style:
        width: "#{@iconSize}px",
      z 'img',
        src: @game.iconImage?.versions[0].url or @game.icon128Url
        width: @iconSize
        height: @iconSize
      z '.z-game-box-info',
        z 'h3', @game.name
        @RatingsWidget
