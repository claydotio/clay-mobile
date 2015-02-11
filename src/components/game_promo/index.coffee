z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

UrlService = require '../../services/url'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class GamePromo
  constructor: ({@game, @width, @height}) ->
    styles.use()

    @width ?= styleConfig.$marketplaceGamePromoWidth
    @height ?= styleConfig.$marketplaceGamePromoHeight

    @gameSubdomainUrl = UrlService.getGameSubdomain {@game}

  loadGame: (e) =>
    e?.preventDefault()

    ga? 'send', 'event', 'game_promo', 'click', @game.key
    User.convertExperiment('game_promo').catch log.trace
    z.router.go UrlService.getGameRoute {@game}
    httpSubDomainUrl = UrlService.getGameSubdomain({@game, protocol: 'http'})
    kik?.picker?(httpSubDomainUrl, {}, -> null)

  render: =>
    z "a.z-game-promo[href=#{@gameSubdomainUrl}]",
      onclick: @loadGame
      style:
        width: "#{width}px",
      z 'img.image',
        src: game.headerImage?.versions[0].url or game.promo440Url
        width: width
        height: height
      z '.info',
        z 'h3', game.name
