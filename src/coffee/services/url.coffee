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
  getMarketplaceGame: (game) =>
    return @getMarketplaceBase() + @getGameRoute game

  # FIXME: game methods should be server-side as class methods in game model
  # relative path to game
  getGameRoute: (game) ->
    return "/game/#{game.key}"

  getGameSubdomain: (game) =>
    return "#{@protocol}//#{game.key}.#{@targetHost}"

  # based on https://support.google.com/analytics/answer/1033867?hl=en
  # but can be changed should we switch to another service
  #
  # as of Sept 2014 this isn't being used anywhere. The main use-case for this
  # is for tracking external links - eg. a callback link for oauth
  # FIXME: support urls with query string already set
  addAnalyticsParams: (baseUrl, {source, medium}) ->
    source ?= 'not_set' # eg promo_image
    medium ?= 'mobile' # eg mobile, desktop

    googleAnalyticsMapping =
      utm_source: source
      utm_medium: medium
      # magic string left here on purpose. if we decide we need to change
      # the campaign name, we'll make this a var & option
      utm_campaign: 'clay_mobile'
    queryStringArray = []
    for param, value of googleAnalyticsMapping
      queryStringArray.push "#{param}=#{encodeURIComponent(value)}"
    queryString = queryStringArray.join('&')

    return "#{baseUrl}?#{queryString}"

module.exports = new UrlService()
