# FIXME: clean up this file. all miscellaneous stuff is being placed here
# for the sake of time

require './polyfill'

_ = require 'lodash'
z = require 'zorium'
log = require 'clay-loglevel'
kik = require 'kik'

config = require './config'
HomePage = require './pages/home'
PlayGamePage = require './pages/play_game'
GamesPage = require './pages/games'
JoinPage = require './pages/join'
LoginPage = require './pages/login'
ForgotPasswordPage = require './pages/forgot_password'
ResetPasswordPage = require './pages/reset_password'
InvitePage = require './pages/invite'
InviteLandingPage = require './pages/invite_landing'
WhatIsClayPage = require './pages/what_is_clay'
FriendsPage = require './pages/friends'
DevLoginPage = require './pages/dev_login'
DevDashboardPage = require './pages/dev_dashboard'
DevEditGamePage = require './pages/dev_edit_game'
PushToken = require './models/push_token'
User = require './models/user'
Developer = require './models/developer'
NavDrawerModel = require './models/nav_drawer'
UrlService = require './services/url'
PortalService = require './services/portal'
ErrorReportService = require './services/error_report'
EnvironmentService = require './services/environment'
KikService = require './services/kik'

baseStyles = require './stylus/base.styl'

ENGAGED_ACTIVITY_TIME = 1000 * 60 # 1min
KIK_PICKER_MIN_TIMEOUT_MS = 200

baseStyles.use()
PortalService.registerMethods()

# Facebook share redirects to ?#_=_, which isn't a route
# TODO: (Austin) better workaround for this
# FIXME: somehow send user back to Kik if they shared from Kik?
if window.location.hash is '#_=_'
  window.location.hash = ''

##############
# KIK PICKER #
##############

# Marketplace or game was loaded in picker
if kik?.picker?.reply
  kikPickerReply = (value = {}) ->
    setTimeout ->
      kik.picker.reply value
    , KIK_PICKER_MIN_TIMEOUT_MS

  if UrlService.isRootPath() # marketplace in picker
    # will throw an error if token exists. better than waiting for roundtrip
    # to check for existence
    PushToken.createForMarketplace()
    .then ->
      throw new Error 'always'
    .catch ->
      kik.getAnonymousUser (anonToken) ->
        kikPickerReply {anonToken}
    .catch (err) ->
      log.trace err
      kikPickerReply {}
  else # game subdomain in picker
    gameKey = UrlService.getSubdomain()
    PushToken.createByGameKey gameKey
    .then ->
      kikPickerReply {}
    .catch (err) ->
      log.trace err
      kikPickerReply {}
  throw new Error 'Stop code execution'

###########
# LOGGING #
###########

ga? 'set', 'dimension1', switch
  when EnvironmentService.isClayApp()
    'clay_app'
  when EnvironmentService.isKikEnabled()
    'kik'
  when EnvironmentService.isFirefoxOS()
    'firefox_os'
  else 'web'

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

z.router.on 'route', (path) ->
  ga? 'send', 'pageview', path

# TODO: (Zoli) route from pathname to hash for kik
# Kik changes app if the url changes, so don't change it
# Also, if someone recieved a link with a hash, respect it
if EnvironmentService.isKikEnabled() or
    not window.history?.pushState or
    window.location.hash

  z.router.setMode 'hash'
else
  z.router.setMode 'pathname'

subdomain = UrlService.getSubdomain()

root = document.getElementById('app')
z.router.setRoot root

if subdomain is 'dev'
  z.router.add '/login', DevLoginPage

  z.router.add '/dashboard', DevDashboardPage
  z.router.add '/dashboard/:tab', DevDashboardPage
  z.router.add '/edit-game', DevEditGamePage
  z.router.add '/edit-game/:currentStep', DevEditGamePage
  z.router.add '/edit-game/:currentStep/:gameId', DevEditGamePage

else
  z.router.add '/', if EnvironmentService.isMobile() \
                    then GamesPage
                    else HomePage
  z.router.add '/games', GamesPage
  z.router.add '/game/:key', PlayGamePage
  z.router.add '/games/:filter', GamesPage
  z.router.add '/join', JoinPage
  z.router.add '/login', LoginPage
  z.router.add '/forgot-password', ForgotPasswordPage
  z.router.add '/reset-password', ResetPasswordPage
  z.router.add '/invite', InvitePage
  z.router.add '/invite-landing/:fromUserId', InviteLandingPage
  z.router.add '/what-is-clay/:fromUserId', WhatIsClayPage
  z.router.add '/friends', FriendsPage

route = ->
  # invite from kik message
  fromUserId = kik?.message?.fromUserId
  if fromUserId
    z.router.go "/invite-landing/#{fromUserId}"
    return

  # Passed via message to denote game (share button in drawer uses this)
  gameKey = kik?.message?.gameKey or (subdomain isnt 'dev' and subdomain)

  if gameKey
    PushToken.createByGameKey gameKey
    .catch log.trace
    z.router.go "/game/#{gameKey}"
  else
    PushToken.createForMarketplace()
    .catch log.trace
    z.router.go()

  # FIXME when zorium hsa better support for redirects, move this up
  if subdomain is 'dev' and z.router.currentPath is null
    User.getMe().then ({id}) ->
      Developer.find({ownerId: id})
    .then (developers) ->
      z.router.go if _.isEmpty developers then '/login' else '/dashboard'

Promise.all [User.incrementVisitCount(), KikService.isFromPush()]
.then ([visitCount, isFromPush]) ->
  if isFromPush
    ga? 'set', 'referrer', 'http://kikpush.claycustomreferrer.com'
.catch log.trace
.then ->
  new Promise (resolve) ->
    #############
    # USER INIT #
    #############

    # If on kik, login with anonymous user token (from marketplace)
    if EnvironmentService.isKikEnabled()
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

  # track kik metrics (users sending messages, etc...)
  kik?.metrics?.enableGoogleAnalytics?()

  ###########
  # ROUTING #
  ###########

  route()

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

  window.setTimeout ->
    User.logEngagedActivity()
    .catch log.trace
  , ENGAGED_ACTIVITY_TIME

  log.info 'App Ready'
.catch log.trace
