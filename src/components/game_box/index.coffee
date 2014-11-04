z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

RatingsWidget = require '../stars'
styleConfig = require '../../stylus/vars.json'
User = require '../../models/user'
UrlService = require '../../services/url'

require './index.styl'

module.exports = class GameBox
  constructor: ({@game, @iconSize}) ->
    @iconSize ?= styleConfig.$marketplaceGameIconWidth
    @RatingsWidget = new RatingsWidget stars: @game.rating

  loadGame: (e) =>
    e?.preventDefault()

    ga? 'send', 'event', 'game_box', 'click', @game.key
    User.convertExperiment('game_box_click').catch log.trace
    z.route UrlService.getGameRoute {@game}
    httpSubDomainUrl = UrlService.getGameSubdomain({@game, protocol: 'http'})
    kik.picker?(httpSubDomainUrl, {}, -> null)

  render: ->
    gameSubdomainUrl = UrlService.getGameSubdomain {@game}
    z "a.game-box[href=#{gameSubdomainUrl}]", {onclick: @loadGame}, [
      z 'img',
        src: @game.icon128Url
        width: @iconSize,
        height: @iconSize
      z '.game-box-info', [
        z 'h3', @game.name
        @RatingsWidget.render()
      ]
    ]
