z = require 'zorium'
kik = require 'kik'
log = require 'clay-loglevel'

User = require '../../models/user'
Game = require '../../models/game'
UrlService = require '../../services/url'

styles = require './index.styl'

module.exports = class GameShoeBox
  constructor: ({@game}) ->
    styles.use()

    @gameSubdomainUrl = UrlService.getGameSubdomain {@game}

  loadGame: (e) =>
    e?.preventDefault()

    ga? 'send', 'event', 'game_shoe_box', 'click', @game.key
    z.router.go UrlService.getGameRoute {@game}
    httpSubDomainUrl = UrlService.getGameSubdomain({@game, protocol: 'http'})
    kik?.picker?(httpSubDomainUrl, {}, -> null)

  render: =>
    z "a.z-game-shoe-box[href=#{@gameSubdomainUrl}]", {onclick: @loadGame}, [
      z 'img',
        src: Game.getIconUrl @game
      z '.z-game-shoe-box-info', [
        z 'h3', @game.name
      ]
      z '.z-game-shoe-box-play',
        z 'i.icon.icon-play-circle'
    ]
