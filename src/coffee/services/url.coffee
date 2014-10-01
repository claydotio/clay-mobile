kik = require 'kik'

config = require '../config'

class UrlService
  constructor: ->
    host = window.location.host
    @targetHost = config.HOSTNAME

    @protocol = 'http:'

    # if on subdomain (game page), don't use card:// protocol
    unless host is @targetHost
      @protocol = if kik?.enabled then 'card:' else 'http:'

  # clay.io/whatever => true, subdomain.clay.io/whatever => false
  isRootPath: =>
    host = window.location.host
    @targetHost = config.HOSTNAME
    return host is @targetHost

  getMarketplaceBase: =>
    return "#{@protocol}//#{@targetHost}"

  # full path to marketplace and game
  getMarketplaceGame: ({game}) =>
    return @getMarketplaceBase() + '/#' + @getGameRoute {game}

  # FIXME: game methods should be server-side as class methods in game model
  # relative path to game
  getGameRoute: ({game}) ->
    return "/game/#{game.key}"

  getGameSubdomain: ({game, protocol}) =>
    protocol ?= @protocol
    return "#{protocol}//#{game.key}.#{@targetHost}"

module.exports = new UrlService()
