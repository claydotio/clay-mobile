z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

RatingsWidget = require '../stars'
UrlService = require '../../services/url'
User = require '../../models/user'
styleConfig = require '../../stylus/vars.json'

styles = require './with_info.styl'

module.exports = class GamePromo
  constructor: ({@game, @width, @height}) ->
    styles.use()

    @width ?= styleConfig.$marketplaceGamePromoWidth
    @height ?= styleConfig.$marketplaceGamePromoHeight

    @RatingsWidget = new RatingsWidget stars: @game.rating
    @gameSubdomainUrl = UrlService.getGameSubdomain {@game}

  loadGame: (e) =>
    e?.preventDefault()

    ga? 'send', 'event', 'game_promo_with_info', 'click', @game.key
    User.convertExperiment('game_promo_with_info').catch log.trace
    z.router.go UrlService.getGameRoute {@game}
    httpSubDomainUrl = UrlService.getGameSubdomain({@game, protocol: 'http'})
    kik.picker?(httpSubDomainUrl, {}, -> null)

  render: =>
    z "a.game-promo[href=#{@gameSubdomainUrl}]",
      onclick: @loadGame
      style: "width: #{@width}px;",
      z 'img',
        src: @game.promo440Url
        width: @width
        height: @height
      z '.game-promo-info',
        z 'h3', @game.name
        @RatingsWidget
