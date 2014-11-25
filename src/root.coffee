# FIXME: clean up this file. all miscellaneous stuff is being placed here
# for the sake of time

require './polyfill'

_ = require 'lodash'
z = require 'zorium'
log = require 'clay-loglevel'
kik = require 'kik'

config = require './config'
PlayGamePage = require './pages/play_game'
GamesPage = require './pages/games'
PushToken = require './models/push_token'
User = require './models/user'
UrlService = require './services/url'
PortalService = require './services/portal'

ENGAGED_ACTIVITY_TIME = 1000 * 60 # 1min

PortalService.registerMethods()

##############
# KIK PICKER #
##############

# Marketplace or game was loaded in picker
if kik?.picker?.reply
  if UrlService.isRootPath() # marketplace
    PushToken.createForMarketplace()
    .then ->
      User.getMe()
      .then (user) ->
        kik.getAnonymousUser (token) ->
          kik.picker.reply {token, user}
      .catch (err) ->
        log.trace err
        kik.getAnonymousUser (token) ->
          kik.picker.reply {token}
    .catch (err) ->
      log.trace err
      kik.picker.reply()
  else # game subdomain
    gameKey = UrlService.getSubdomain()
    PushToken.createByGameKey gameKey
    .then ->
      kik.picker.reply()
    .catch (err) ->
      log.trace err
      kik.picker.reply()
  throw new Error 'Stop code execution'

###########
# LOGGING #
###########

reportError = ->
  # Remove the circular dependency within error objects
  args = _.map arguments, (arg) ->

    if arg instanceof Error and arg.stack
    then arg.stack
    else if arg instanceof Error
    then arg.message
    else if arg instanceof ErrorEvent and arg.error
    then arg.error.stack
    else if arg instanceof ErrorEvent
    then arg.message
    else arg

  window.fetch config.API_URL + '/log',
    method: 'POST'
    headers:
      'Accept': 'application/json'
      'Content-Type': 'application/json'
    body:
      JSON.stringify message: args.join ' '
  .catch (err) ->
    console?.error err

window.addEventListener 'error', reportError

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

###########
# ROUTING #
###########

# TODO: (Zoli) route from pathname to hash for kik
# Kik changes app if the url changes, so don't change it
# Also, if someone recieved a link with a hash, respect it
if kik?.enabled or not window.history?.pushState or window.location.hash
  z.router.setMode 'hash'
else
  z.router.setMode 'pathname'

root = document.getElementById('app')
z.router.setRoot root
z.router.add '/', GamesPage
z.router.add '/games', GamesPage
z.router.add '/game/:key', PlayGamePage
z.router.add '/games/:filter', GamesPage

# track kik metrics (users sending messages, etc...)
kik?.metrics?.enableGoogleAnalytics?()

# Passed via message to denote game (share button in drawer uses this)
kikGameKey = kik?.message?.gameKey

shouldRouteToGamePage = kikGameKey or
                        (not UrlService.isRootPath() and not config.MOCK)
gameKey = null
if shouldRouteToGamePage
  if kikGameKey
    z.router.go "/game/#{kikGameKey}"
  else # subdomain
    gameKey = UrlService.getSubdomain()
    PushToken.createByGameKey gameKey
    # marketplace in picker, causing it to appear in side-bar
    # This is also used to pass the marketplace anon-user token
    # which is used for tracking uniq share conversions
    # And also for passing the user object through
    marketplaceBaseUrl = UrlService.getMarketplaceBase({protocol: 'http'})
    kik?.picker? marketplaceBaseUrl, {}, (res) ->
      kikAnonymousToken = res.token
      if res.user
        User.setMe res.user

      z.router.go "/game/#{gameKey}"
else
  PushToken.createForMarketplace()
  z.router.go()

log.info 'App Ready'
