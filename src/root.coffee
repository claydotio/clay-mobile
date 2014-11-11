# FIXME: clean up this file. all miscellaneous stuff is being placed here
# for the sake of time

# Bind polyfill (phantomjs doesn't support bind)
# Tossing this in here is terrible practice, don't ever do it
# This is a short-term fix until we have a more elegant bind polyfill
# coffeelint: disable=missing_fat_arrows
unless Function::bind
  Function::bind = (oThis) ->

    # closest thing possible to the ECMAScript 5
    # internal IsCallable function
    throw new TypeError(
      'Function.prototype.bind - what is trying to be bound is not callable'
    ) if typeof this isnt 'function'
    aArgs = Array::slice.call(arguments, 1)
    fToBind = this
    fNOP = -> null

    fBound = ->
      fToBind.apply(
        (if this instanceof fNOP and oThis then this else oThis),
        aArgs.concat(Array::slice.call(arguments))
      )

    fNOP:: = @prototype
    fBound:: = new fNOP()
    fBound
# coffeelint: disable=missing_fat_arrows

_ = require 'lodash'
z = require 'zorium'
log = require 'clay-loglevel'
Q = require 'q'
kik = require 'kik'
require 'matchMedia'

config = require './config'
PlayGamePage = require './pages/play_game'
GamesPageControl = require './pages/games'
GamesPageRecentTabs = require './pages/games/recent_tabs'
GamesPageRecentList = require './pages/games/recent_list'
GamesPageRecentBoxes = require './pages/games/recent_boxes'
PushToken = require './models/push_token'
User = require './models/user'
UrlService = require './services/url'

ENGAGED_ACTIVITY_TIME = 1000 * 60 # 1min

##############
# KIK PICKER #
##############

# Marketplace or game was loaded in picker
if kik?.picker?.reply
  if UrlService.isRootPath() # marketplace
    PushToken.createForMarketplace()
    .finally ->
      kik.getAnonymousUser (token) ->
        kik.picker.reply {token}
    .catch (err) ->
      log.trace err
  else # game subdomain
    gameKey = UrlService.getSubdomain()
    PushToken.createByGameKey gameKey
    .finally ->
      kik.picker.reply()
    .catch (err) ->
      log.trace err
  throw new Error 'Stop code execution'

###########
# LOGGING #
###########

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
    background: true
  .catch (err) ->
    console?.error err

window.addEventListener 'error', reportError
window.addEventListener 'fb-flo-reload', z.redraw

if config.ENV isnt config.ENVS.PROD
  log.enableAll()
else
  log.setLevel 'error'
  log.on 'error', reportError
  log.on 'trace', reportError

############
# Z-FACTOR #
############
shareOriginUserId = kik?.message?.share?.originUserId

if shareOriginUserId
  User.setExperimentsFrom shareOriginUserId
  .catch log.trace
  User.convertExperiment 'hit_from_share'
  .catch log.trace

hasVisitedBefore = _.contains document.cookie, 'accessToken'

#####################
# ENGAGED GAMEPLAYS #
#####################

# This is set if on kik and on a subdomain
# using the picker trigger for push tokens
kikAnonymousToken = null

window.setTimeout ->
  User.logEngagedActivity()
  .catch log.trace
, ENGAGED_ACTIVITY_TIME

if shareOriginUserId and not hasVisitedBefore
  # Kik clears tokens often. Use their anon-token to identify users
  # The anon-token is unique for each 'app', so always use the marketplace one
  if kik.enabled
    if not kikAnonymousToken
      kik.getAnonymousUser (token) ->
        User.convertExperiment 'new_unique_from_share', {uniq: token}
        .catch log.trace
    else
      User.convertExperiment 'new_unique_from_share', {uniq: kikAnonymousToken}
      .catch log.trace
  else
    User.convertExperiment 'new_unique_from_share'
    .catch log.trace

####################
# GOOGLE ANALYTICS #
####################

# track A/B tests in Google Analytics
# Google's intended solution for this is custom dimensions
# https://developers.google.com/analytics/devguides/platform/customdimsmets
# however, that requires adding each dimension inside of FA's admin panel.
# using events we can get the same results with a filter for users with
# specific events
User.getExperiments().then (params) ->
  return unless ga
  for experimentParam, experimentTestGroup of params
    ga 'send', 'event', 'A/B Test', experimentParam, experimentTestGroup

route = (routes) ->
  _.transform routes, (result, Component, route) ->
    result[route] =
      controller: => @component = new Component(z.route.param)
      view: => @component.render()

###########
# ROUTING #
###########

# TODO: (Zoli) route from pathname to hash for kik
# Kik changes app if the url changes, so don't change it
# Also, if someone recieved a link with a hash, respect it
if kik?.enabled or not window.history?.pushState or window.location.hash
  z.route.mode = 'hash'
else
  z.route.mode = 'pathname'

User.getExperiments().then (params) ->
  switch params.gamesPage
    when 'recent_tabs' then GamesPageRecentTabs
    when 'recent_list' then GamesPageRecentList
    when 'recent_boxes' then GamesPageRecentBoxes
    else GamesPageControl

.then (GamesPage) ->

  z.route document.getElementById('app'), '/', route(
    '/': GamesPage
    '/games': GamesPage
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
      PushToken.createByGameKey gameKey
      # marketplace in picker, causing it to appear in side-bar
      # This is also used to pass the marketplace anon-user token
      # which is used for tracking uniq share conversions
      marketplaceBaseUrl = UrlService.getMarketplaceBase({protocol: 'http'})
      kik?.picker? marketplaceBaseUrl, {}, (res) ->
        kikAnonymousToken = res.token

    z.route "/game/#{gameKey}"
  else
    PushToken.createForMarketplace()

  log.info 'App Ready'


  ##########################
  # CSS / DEVICE DETECTION #
  ##########################

  # TODO: (Austin) Feature-detection for SVG, slow devices
  # we'll want to move this somewhere cleaner
  bodyClasses = []
  svgSupport = !! document.createElementNS?('http://www.w3.org/2000/svg', 'svg')
                  .createSVGRect
  unless svgSupport
    bodyClasses.push 'no-svg'

  isAndroid2 = ->
    # Android 2.x detection
    parseInt(navigator.userAgent.match(/Android\s([0-9\.]*)/)?[1], 10) is 2

  isSlowDevice = isAndroid2

  if isSlowDevice()
    bodyClasses.push 'is-slow-device'

  if isAndroid2()
    bodyClasses.push 'is-android-2-3'

  document.body.className += ' ' + bodyClasses.join ' '
