z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../lib/request'
localstore = require '../lib/localstore'
config = require '../config'
EnvironmentService = require '../services/environment'

PATH = config.PUBLIC_CLAY_API_URL + '/users'
DEFAULT_PROFILE_PIC = '//cdn.wtf/d/images/general/profile-square.png'
LOCALSTORE_VISIT_COUNT_KEY = 'user:visit_count'
LOCALSTORE_FRIENDS = 'user:friends'
SMALL_AVATAR_SIZE = 96
LARGE_AVATAR_SIZE = 512

# FIXME: this is a hack for detecting if we've tried setting `me` or
# not. It'll get resolved when we implement streams.
me = z.observe Promise.resolve 'unset'
experiments = null

getCookieValue = (key) ->
  match = document.cookie.match('(^|;)\\s*' + key + '\\s*=\\s*([^;]+)')
  return if match then match.pop() else null

secondLevelDomain = window.location.hostname.split('.').slice(-2).join('.')
# The '.' prefix allows subdomains access
domain = '.' + secondLevelDomain

setHostCookie = (key, value) ->
  # The '.' prefix allows subdomains access
  document.cookie = "#{key}=#{value};path=/;domain=#{domain}"

deleteHostCookie = (key) ->
  document.cookie = "#{key}=;path=/;domain=#{domain};" +
                    'expires=Thu, 01 Jan 1970 00:00:01 GMT'

class User
  AVATAR_SIZES:
    SMALL: SMALL_AVATAR_SIZE
    LARGE: LARGE_AVATAR_SIZE

  signedUpThisSession: false

  getMe: =>
    if me() is 'unset'
      me.set @loginAnon()

      # Save accessToken in cookie
      me.then (user) ->
        setHostCookie config.ACCESS_TOKEN_COOKIE_KEY, user.accessToken
      .catch log.trace

    return me

  setMe: (_me) ->
    me.set _me

    # Save accessToken in cookie
    me.then (user) ->
      setHostCookie config.ACCESS_TOKEN_COOKIE_KEY, user.accessToken
    .catch log.trace

    experiments = me.then (user) ->
      request config.PUBLIC_FC_API_URL + '/experiments',
        method: 'POST'
        body:
          userId: user.id
    return me

  updateMe: (userUpdate) =>
    @getMe().then (me) =>
      request "#{PATH}/me",
        method: 'PUT'
        qs:
          accessToken: me.accessToken
        body: userUpdate
      .then (res) =>
        @setMe res

  getById: (userId) =>
    @getMe().then ({accessToken}) ->
      request PATH + "/#{userId}",
        method: 'GET'
        qs:
          accessToken: accessToken

  isLoggedIn: do ->
    o_isLoggedIn = z.observe me.then (me) ->
      Boolean me?.phone

    me (me) ->
      o_isLoggedIn.set Promise.resolve Boolean me?.phone
    ->
      o_isLoggedIn

  logEngagedActivity: =>
    @getMe().then (me) =>
      Promise.all [
        @convertExperiment('engaged_activity')
        request PATH + '/me/lastEngagedActivity',
          method: 'POST'
          qs: {accessToken: me.accessToken}
      ]
      .then ([exp, res]) ->
        res

  getExperiments: =>
    unless experiments
      experiments = @getMe().then (user) ->
        request config.PUBLIC_FC_API_URL + '/experiments',
          method: 'POST'
          body:
            userId: user.id

    return experiments

  setExperimentsFrom: (shareOriginUserId) =>
    experiments = @getMe().then (user) ->
      request config.PUBLIC_FC_API_URL + '/experiments',
        method: 'POST'
        body:
          fromUserId: shareOriginUserId
          userId: user.id

  convertExperiment: (event, {uniq} = {}) =>
    @getMe().then (user) ->
      request config.PUBLIC_FC_API_URL + '/conversions',
        method: 'POST'
        body:
          event: event
          uniq: uniq
          userId: user.id

  addRecentGame: (gameId) =>
    @getMe().then (me) ->
      request PATH + '/me/links/recentGames',
        method: 'PATCH'
        qs:
          accessToken: me.accessToken
        body:
          [ op: 'add', path: '/-', value: gameId ]

  incrementVisitCount: ->
    localstore.get LOCALSTORE_VISIT_COUNT_KEY
    .then (visitCountObject) ->
      visitCount = if visitCountObject?.count then visitCountObject.count else 0
      localstore.set LOCALSTORE_VISIT_COUNT_KEY, {count: visitCount + 1}
    .then (visitCountObject) ->
      newVisitCount = visitCountObject.count
      # visit count dimension in GA
      ga? 'set', 'dimension2', newVisitCount
      return newVisitCount

  getVisitCount: ->
    localstore.get LOCALSTORE_VISIT_COUNT_KEY
    .then (visitCountObject) ->
      visitCountObject?.count

  addFriend: (userId) =>
    ga? 'send', 'event', 'user', 'add_friend', userId

    @getMe().then ({accessToken}) ->
      request PATH + '/me/friends',
        method: 'POST',
        qs:
          accessToken: accessToken
        body:
          {userId}

  getFriends: =>
    @getMe().then ({accessToken}) ->
      request PATH + '/me/friends',
        method: 'GET'
        qs:
          accessToken: accessToken

  getLocalNewFriends: =>
    @isLoggedIn().then (isLoggedIn) =>
      if isLoggedIn and not EnvironmentService.isiOS()
        Promise.all [
          localstore.get LOCALSTORE_FRIENDS
          @getFriends()
        ]
        .then ([localFriends, friends]) ->
          localstore.set LOCALSTORE_FRIENDS, friends
          return _.filter friends, localFriends
      else
        Promise.resolve []

  loginAnon: ->
    request PATH + '/login/anon',
      method: 'POST'
      qs:
        accessToken: getCookieValue config.ACCESS_TOKEN_COOKIE_KEY

  loginKikAnon: (kikAnonToken) ->
    request PATH + '/login/kikAnon',
      method: 'POST'
      body:
        {kikAnonToken}

  loginBasic: ({email, password}) =>
    @getMe().then (me) ->
      request PATH + '/login/basic',
        method: 'POST'
        qs:
          accessToken: me.accessToken
        body: {
          email
          password
        }

  loginPhone: ({phone, password, recoveryToken}) =>
    @getMe().then (me) ->
      request PATH + '/login/phone',
        method: 'POST'
        qs:
          accessToken: me.accessToken
        body: {
          phone
          password
          recoveryToken
        }

  recoverLogin: ({phone}) =>
    @getMe().then (me) ->
      request PATH + '/login/recovery',
        method: 'POST'
        qs:
          accessToken: me.accessToken
        body: {
          phone
        }

  logout: ->
    deleteHostCookie config.ACCESS_TOKEN_COOKIE_KEY
    @setMe @loginAnon

  getAvatarUrl: (user, {size} = {}) =>
    size ?= @AVATAR_SIZES.SMALL

    if user?.avatarImage
      pxSize = if size is 'large' then LARGE_AVATAR_SIZE else SMALL_AVATAR_SIZE
      avatarObject = _.find user?.avatarImage?.versions, width: pxSize

      return avatarObject.url or DEFAULT_PROFILE_PIC
    else
      return DEFAULT_PROFILE_PIC

  getSignedUpThisSession: =>
    return @signedUpThisSession

  setSignedUpThisSession: (signedUp) =>
    @signedUpThisSession = signedUp

module.exports = new User()
