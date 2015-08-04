z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

UrlService = require '../../services/url'
User = require '../../models/user'
Game = require '../../models/game'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class GamePromo
  constructor: ->
    styles.use()

  loadGame: (game) ->
    ga? 'send', 'event', 'game_promo', 'click', game.key
    z.router.go UrlService.getGameRoute {game}
    httpSubDomainUrl = UrlService.getGameSubdomain({game, protocol: 'http'})
    kik?.picker?(httpSubDomainUrl, {}, -> null)

  render: ({game, width, height}) =>
    width ?= styleConfig.$marketplaceGamePromoWidth
    height ?= styleConfig.$marketplaceGamePromoHeight
    gameSubdomainUrl = UrlService.getGameSubdomain {game}
    backgroundImage = Game.getHeaderImageUrl game

    z "a.z-game-promo[href=#{gameSubdomainUrl}]", {
      onclick: (e) =>
        e?.preventDefault()
        @loadGame game
    },
      z 'div.image',
        style:
          backgroundImage: "url(#{backgroundImage})"
          width: "#{width}px",
          height: "#{height}px"
      z '.info',
        z 'h3', game.name
