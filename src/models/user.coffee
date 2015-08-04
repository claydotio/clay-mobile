z = require 'zorium'
log = require 'clay-loglevel'
_ = require 'lodash'

cookies = require '../lib/cookies'
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
# This doesn't need to be a promise because getMe() will make it a promise
# if it's 'unset', and nothing else accesses `me` directly as a promise
me = z.observe 'unset'

class User
  AVATAR_SIZES:
    SMALL: SMALL_AVATAR_SIZE
    LARGE: LARGE_AVATAR_SIZE

  DEFAULT_NAME: 'Nameless'

  constructor: ->
    @signedUpThisSession = false
    @viewedFirstVisitModalThisSession = false
    me (user) ->
      if user?.accessToken
        cookies.set config.ACCESS_TOKEN_COOKIE_KEY, user.accessToken

  getMe: =>
    if me() is 'unset'
      me.set @loginAnon cookies.get config.ACCESS_TOKEN_COOKIE_KEY

    return me

  #  FIXME: _me must be a promise (streams will hopefully fix)
  setMe: (_me) ->
    me.set _me
    return me

  updateMe: (userUpdate) =>
    @setMe @getMe().then (me) ->
      request "#{PATH}/me",
        method: 'PUT'
        qs:
          accessToken: me.accessToken
        body: userUpdate

  getById: (userId) =>
    @getMe().then ({accessToken}) ->
      request PATH + "/#{userId}",
        method: 'GET'
        qs:
          accessToken: accessToken

  isLoggedIn: do ->
    o_isLoggedIn = z.observe false

    me (me) ->
      o_isLoggedIn.set Promise.resolve Boolean me?.phone
    ->
      o_isLoggedIn

  logEngagedActivity: =>
    @getMe().then (me) ->
      request PATH + '/me/lastEngagedActivity',
        method: 'POST'
        qs: {accessToken: me.accessToken}

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

  loginAnon: (accessToken) ->
    accessToken ?= null

    request PATH + '/login/anon',
      method: 'POST'
      qs:
        accessToken: accessToken

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

  logout: =>
    @setMe @loginAnon()

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

  getViewedFirstVisitModalThisSession: ->
    return @viewedFirstVisitModalThisSession

  setViewedFirstVisitModalThisSession: (viewed) ->
    @viewedFirstVisitModalThisSession = viewed

module.exports = new User()
