kik = require 'kik'

config = require '../config'
EnvironmentService = require './environment'

host = window.location.host

class UrlService
  # clay.io/whatever => true, subdomain.clay.io/whatever => false
  isRootPath: ->
    return host is config.HOST

  getMarketplaceBase: ({protocol} = {}) ->
    protocol ?= if EnvironmentService.isKikEnabled() then 'card' else 'http'
    return "#{protocol}://#{config.HOST}"

  # full path to marketplace and game
  getMarketplaceGame: ({game}) =>
    return @getMarketplaceBase({protocol: 'http'}) + '/#' + @getGameRoute {game}

  # FIXME: game methods should be server-side as class methods in game model
  # relative path to game
  getGameRoute: ({game}) ->
    return "/game/#{game?.key}"

  # returns the full url to a game's subdomain page (eg http://slime.clay.io)
  getGameSubdomain: ({game, protocol}) =>
    protocol ?= if EnvironmentService.isKikEnabled() and @isRootPath() \
                then 'card' else 'http'
    return "#{protocol}://#{game?.key}.#{config.HOST}"

  # url is optional, if undefined use config.HOST as base domain
  getSubdomain: ({url} = {}) ->
    # ignore subdomains which are part of config.HOST, e.g. [192].168.0.0
    url ?= host.replace config.HOST, 'X.XX'
    subdomainRegex = /(?:(?:http|card)[s]*\:\/\/)*(.*?)\.(?=[^\/]*\..{2,5})/i
    matches = subdomainRegex.exec(url)

    matches?[1] or null

  openWindow: (url) ->
    if EnvironmentService.isKikEnabled()
    then kik.open url, true
    else if EnvironmentService.isClayApp()
    then window.open url, '_system'
    else window.open url, '_blank'


module.exports = new UrlService()
