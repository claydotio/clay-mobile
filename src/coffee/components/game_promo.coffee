z = require 'zorium'
config = require 'config'

UrlService = require '../services/url'

module.exports = class GamePromo
  constructor: ({@game, @width, @height}) -> null

  loadGame: =>
    ga('send', 'event', 'game_promo', 'click', @game.key)
    # redirect to clay marketplace and append the route
    window.location.href = UrlService.getMarketplaceGame @game.getRoute()
    kik.picker?(@game.getSubdomainUrl(), {}, -> null)

  render: =>
    z '.game-promo', {onclick: @loadGame},
      z 'img',
        src: @game.promo440Url
        width: @width
        height: @height
