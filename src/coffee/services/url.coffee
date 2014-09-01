config = require '../config'

class UrlService
  constructor: ->
    host = window.location.host
    @targetHost = config.HOSTNAME

    @protocol = 'http:'

    # if on subdomain (game page), don't use card:// protocol
    unless host == @targetHost
      @protocol = if kik?.enabled then 'card:' else 'http:'

  getMarketplaceBase: =>
    return "#{@protocol}//#{@targetHost}"

  getMarketplaceGame: (gameRoute) =>
    return @getMarketplaceBase() + gameRoute

module.exports = new UrlService()
