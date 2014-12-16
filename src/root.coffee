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
DevDashboardPage = require './pages/dev_dashboard'
DevDashboardAddGamePage = require './pages/dev_dashboard_add_game'
PushToken = require './models/push_token'
User = require './models/user'
UrlService = require './services/url'
PortalService = require './services/portal'
ErrorReportService = require './services/error_report'

ENGAGED_ACTIVITY_TIME = 1000 * 60 # 1min

PortalService.registerMethods()

##############
# KIK PICKER #
##############

# Marketplace or game was loaded in picker
if kik?.picker?.reply
  if UrlService.isRootPath() # marketplace in picker
    # will throw an error if token exists. better than waiting for roundtrip
    # to check for existence
    PushToken.createForMarketplace()
    .then ->
      throw new Error 'always'
    .catch ->
      kik.getAnonymousUser (anonToken) ->
        kik.picker.reply {anonToken}
    .catch (err) ->
      log.trace err
      kik.picker.reply {}
  else # game subdomain in picker
    gameKey = UrlService.getSubdomain()
    PushToken.createByGameKey gameKey
    .then ->
      kik.picker.reply {}
    .catch (err) ->
      log.trace err
      kik.picker.reply {}
  throw new Error 'Stop code execution'

###########
# LOGGING #
###########

window.addEventListener 'error', ErrorReportService.report

if config.ENV isnt config.ENVS.PROD
  log.enableAll()
else
  log.setLevel 'error'
  log.on 'error', ErrorReportService.report
  log.on 'trace', ErrorReportService.report


#################
# ROUTING SETUP #
#################

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

z.router.add '/developers/dashboard', DevDashboardPage
z.router.add '/developers/dashboard/add-game', DevDashboardAddGamePage

new Promise (resolve) ->
  #############
  # USER INIT #
  #############

  # If on kik, login with anonymous user token (from marketplace)
  if kik?.enabled
    if UrlService.isRootPath()
      kik.getAnonymousUser (token) ->
        resolve token
    else if kik?.picker
      marketplaceBaseUrl = UrlService.getMarketplaceBase({protocol: 'http'})
      kik?.picker? marketplaceBaseUrl, {}, (res) ->
        resolve(res?.anonToken)
    else resolve()
  else resolve()
.then (maybeKikAnonToken) ->

  if maybeKikAnonToken
    User.setMe User.loginKikAnon(maybeKikAnonToken)
    .catch log.trace

  ############
  # Z-FACTOR #
  ############

  shareOriginUserId = kik?.message?.share?.originUserId
  isFromShare = Boolean shareOriginUserId

  if isFromShare
    User.setExperimentsFrom shareOriginUserId
    .then ->
      User.convertExperiment 'hit_from_share'
    .catch log.trace

  #####################
  # ENGAGED GAMEPLAYS #
  #####################

  hasVisitedBefore = _.contains document.cookie, 'accessToken'

  if isFromShare and not hasVisitedBefore
    # The anon-token is unique for each 'app', so always use the marketplace one
    uniqBody = if maybeKikAnonToken then {uniq: maybeKikAnonToken} else {}
    User.convertExperiment 'new_unique_from_share', uniqBody
    .catch log.trace

  ####################
  #    ANALYTICS     #
  ####################

  # track A/B tests in Google Analytics
  # Google's intended solution for this is custom dimensions
  # https://developers.google.com/analytics/devguides/platform/customdimsmets
  # however, that requires adding each dimension inside of FA's admin panel.
  # using events we can get the same results with a filter for users with
  # specific events
  User.getExperiments().then (params) ->
    unless ga
      return
    for experimentParam, experimentTestGroup of params
      ga 'send', 'event', 'A/B Test', experimentParam, experimentTestGroup
  .catch log.trace

  # track kik metrics (users sending messages, etc...)
  kik?.metrics?.enableGoogleAnalytics?()

  window.setTimeout ->
    User.logEngagedActivity()
    .catch log.trace
  , ENGAGED_ACTIVITY_TIME

  ###########
  # ROUTING #
  ###########

  # Passed via message to denote game (share button in drawer uses this)
  gameKey = kik?.message?.gameKey or UrlService.getSubdomain()

  if gameKey
    PushToken.createByGameKey gameKey
    z.router.go "/game/#{gameKey}"
  else
    PushToken.createForMarketplace()
    z.router.go()

  log.info 'App Ready'
.catch log.trace
