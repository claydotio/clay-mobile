z = require 'zorium'
config = require 'config'

UrlService = require '../services/url'

module.exports = class GamePromo
  constructor: ({@game, @width, @height}) -> null

  loadGame: (e) =>
    e?.preventDefault()

    # technically we could use a URL to track (a la GA URL builder) BUT
    # Kik things pages with query params are a different app, and it's cleaner
    # to have all metrics we're tracking in a single format (events)

    # if already on marketplace, keep them there with game route, otherwise
    # hard redirect to marketplace / gameRoute
    redirect = =>
      if UrlService.isRootPath()
        z.route UrlService.getGameRoute @game
      else
        window.location.href = UrlService.getMarketplaceGame @game

    # if ga is loaded in, send the event, then load the marketplace
    if ga
      ga 'send', 'event', 'game_promo', 'click', @game.key,
        {hitCallback: redirect}
    else
      redirect()

  render: =>
    gameSubdomainUrl = UrlService.getGameSubdomain @game
    z "a.game-promo[href=#{gameSubdomainUrl}]", {onclick: @loadGame},
      z 'img',
        src: @game.promo440Url
        width: @width
        height: @height
