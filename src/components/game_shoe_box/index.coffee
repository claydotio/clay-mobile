z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

RatingsWidget = require '../stars'
User = require '../../models/user'
UrlService = require '../../services/url'

styles = require './index.styl'

module.exports = class GameShoeBox
  constructor: ({@game}) ->
    styles.use()

    @RatingsWidget = new RatingsWidget stars: @game.rating
    @gameSubdomainUrl = UrlService.getGameSubdomain {@game}

  loadGame: (e) =>
    e?.preventDefault()

    ga? 'send', 'event', 'game_shoe_box', 'click', @game.key
    User.convertExperiment('game_shoe_box_click').catch log.trace
    z.router.go UrlService.getGameRoute {@game}
    httpSubDomainUrl = UrlService.getGameSubdomain({@game, protocol: 'http'})
    kik.picker?(httpSubDomainUrl, {}, -> null)

  render: =>
    z "a.z-game-shoe-box[href=#{@gameSubdomainUrl}]", {onclick: @loadGame}, [
      z 'img',
        src: @game.icon128Url
      z '.z-game-shoe-box-info', [
        z 'h3', @game.name
        @RatingsWidget
      ]
      z '.z-game-shoe-box-play',
        z 'i.icon.icon-play-circle'
    ]
