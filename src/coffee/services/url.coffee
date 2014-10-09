kik = require 'kik'

config = require '../config'

host = window.location.host

class UrlService
  constructor: ->
    @targetHost = config.HOSTNAME

    @protocol = 'http'

    # if on subdomain (game page), don't use card:// protocol
    unless host is @targetHost
      @protocol = if kik?.enabled then 'card' else 'http'

  # clay.io/whatever => true, subdomain.clay.io/whatever => false
  isRootPath: =>
    @targetHost = config.HOSTNAME
    return host is @targetHost

  getMarketplaceBase: ({protocol} = {}) =>
    protocol ?= @protocol
    return "#{protocol}://#{@targetHost}"

  # full path to marketplace and game
  getMarketplaceGame: ({protocol, game}) =>
    return @getMarketplaceBase({protocol}) + '/#' + @getGameRoute {game}

  # FIXME: game methods should be server-side as class methods in game model
  # relative path to game
  getGameRoute: ({game}) ->
    return "/game/#{game.key}"

  # returns the full url to a game's subdomain page (eg http://slime.clay.io)
  getGameSubdomain: ({game, protocol}) =>
    protocol ?= @protocol
    return "#{protocol}://#{game.key}.#{@targetHost}"

  # url is optional, if undefined, uses current url (window.location.host)
  getSubdomain: ({url} = {}) ->
    url ?= host
    subdomainRegex = /(?:(?:http|card)[s]*\:\/\/)*(.*?)\.(?=[^\/]*\..{2,5})/i
    matches = subdomainRegex.exec(url)
    if matches and matches[1] then matches[1] else null

module.exports = new UrlService()
