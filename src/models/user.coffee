log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../lib/request'
localstore = require '../lib/localstore'
config = require '../config'

PATH = config.PUBLIC_CLAY_API_URL + '/users'
LOCALSTORE_VISIT_COUNT_KEY = 'user:visit_count'

me = null
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

  getMe: =>
    unless me
      me = @loginAnon()

      # Save accessToken in cookie
      me.then (user) ->
        setHostCookie config.ACCESS_TOKEN_COOKIE_KEY, user.accessToken
      .catch log.trace

    return me

  setMe: (_me) ->
    me = Promise.resolve _me

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

  logout: ->
    deleteHostCookie config.ACCESS_TOKEN_COOKIE_KEY
    @setMe @loginAnon

module.exports = new User()
