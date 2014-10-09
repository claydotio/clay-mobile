# FIXME: clean up this file. all miscellaneous stuff is being placed here
# for the sake of time

_ = require 'lodash'
z = require 'zorium'
log = require 'clay-loglevel'
Q = require 'q'
kik = require 'kik'

config = require './config'
GamesPage = require './pages/games'
PlayGamePage = require './pages/play_game'
PushToken = require './models/push_token'
User = require './models/user'
UrlService = require './services/url'

ENGAGED_ACTIVITY_TIME = 1000 * 60 # 1min

# Marketplace or game was loaded in picker
if kik?.picker?.reply
  if UrlService.isRootPath() # marketplace
    PushToken.all('pushTokens').createForMarketplace()
    .finally ->
      kik.picker.reply()
    .catch (err) ->
      log.trace err
  else # game subdomain
    gameKey = UrlService.getSubdomain()
    PushToken.all('pushTokens').createByGameKey gameKey
    .finally ->
      kik.picker.reply()
    .catch (err) ->
      log.trace err
  return # stop executing code

reportError = ->

  # Remove the circular dependency within error objects
  args = _.map arguments, (arg) ->
    if arg instanceof Error
    then arg.stack
    else if arg instanceof ErrorEvent
    then arg.error.stack
    else arg

  Q z.request
    method: 'POST'
    url: config.API_PATH + '/log'
    data:
      message: args.join ' '
  .catch (err) ->
    console?.error err

window.addEventListener 'error', reportError
window.addEventListener 'fb-flo-reload', z.redraw

window.setTimeout ->
  User.logEngagedActivity()
  .catch log.trace
, ENGAGED_ACTIVITY_TIME

if config.ENV isnt config.ENVS.PROD
  log.enableAll()
else
  log.setLevel 'error'
  log.on 'error', reportError
  log.on 'trace', reportError

route = (routes) ->
  _.transform routes, (result, Component, route) ->
    result[route] =
      controller: => @component = new Component(z.route.param)
      view: => @component.render()

# TODO: (Zoli) route from pathname to hash for kik
# Kik changes app if the url changes, so don't change it
# Also, if someone recieved a link with a hash, respect it
if kik?.enabled or not window.history?.pushState or window.location.hash
  z.route.mode = 'hash'
else
  z.route.mode = 'pathname'

z.route document.getElementById('app'), '/', route(
  '/': GamesPage
  '/game/:key': PlayGamePage
  '/games/:filter': GamesPage
)

# track kik metrics (users sending messages, etc...)
kik?.metrics?.enableGoogleAnalytics?()

# Passed via message to denote game (share button in drawer uses this)
kikGameKey = kik?.message?.gameKey

shouldRouteToGamePage = kikGameKey or
                        (not UrlService.isRootPath() and not config.MOCK)
if shouldRouteToGamePage
  if kikGameKey
    gameKey = kikGameKey
  else # subdomain
    gameKey = UrlService.getSubdomain()
    PushToken.all('pushTokens').createByGameKey gameKey
    # marketplace in picker
    marketplaceBaseUrl = UrlService.getMarketplaceBase({protocol: 'http'})
    kik?.picker?(marketplaceBaseUrl, {}, -> null)

  z.route "/game/#{gameKey}"

log.info 'App Ready'

# TODO: (Austin) Feature-detection for SVG, slow devices
# we'll want to move this somewhere cleaner
bodyClasses = []
svgSupport = !! document.createElementNS?('http://www.w3.org/2000/svg', 'svg')
                .createSVGRect
unless svgSupport
  bodyClasses.push 'no-svg'

isAndroid2 = ->
  # Android 2.x detection
  parseInt(navigator.userAgent.match(/Android\s([0-9\.]*)/)?[1], 10) == 2

isSlowDevice = isAndroid2

if isSlowDevice()
  bodyClasses.push 'is-slow-device'

if isAndroid2()
  bodyClasses.push 'is-android-2-3'

document.body.className += ' ' + bodyClasses.join ' '
