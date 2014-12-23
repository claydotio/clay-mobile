log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../lib/request'
config = require '../config'

PATH = config.CLAY_API_URL + '/users'

me = null
experiments = null

getCookieValue = (key) ->
  match = document.cookie.match('(^|;)\\s*' + key + '\\s*=\\s*([^;]+)')
  return if match then match.pop() else null

setHostCookie = (key, value) ->
  secondLevelDomain = window.location.hostname.split('.').slice(-2).join('.')
  # The '.' prefix allows subdomains access
  domain = '.' + secondLevelDomain
  document.cookie = "#{key}=#{value}"
  document.cookie = "#{key}=#{value};path=/;domain=#{domain}"

class User

  getMe: ->
    unless me
      me = if window._clay?.me
      then Promise.resolve window._clay.me
      else request PATH + '/login/anon',
        method: 'POST'
        qs:
          accessToken: getCookieValue 'accessToken'

      # Save accessToken in cookie
      me.then (user) ->
        setHostCookie 'accessToken', user.accessToken
      .catch log.trace

    return me

  setMe: (_me) ->
    me = Promise.resolve _me

    # Save accessToken in cookie
    me.then (user) ->
      setHostCookie 'accessToken', user.accessToken
    .catch log.trace

    experiments = me.then (user) ->
      request config.FC_API_URL + '/experiments',
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
      experiments = if window._clay?.experiments
      then Promise.resolve window._clay.experiments
      else @getMe().then (user) ->
        request config.FC_API_URL + '/experiments',
          method: 'POST'
          body:
            userId: user.id

    return experiments

  setExperimentsFrom: (shareOriginUserId) =>
    experiments = @getMe().then (user) ->
      request config.FC_API_URL + '/experiments',
        method: 'POST'
        body:
          fromUserId: shareOriginUserId
          userId: user.id

  convertExperiment: (event, {uniq} = {}) =>
    @getMe().then (user) ->
      request config.FC_API_URL + '/conversions',
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

  loginKikAnon: (kikAnonToken) =>
    @getMe().then (me) ->
      request PATH + '/login/kikAnon',
        method: 'POST'
        qs:
          accessToken: me.accessToken
        body:
          kikAnonToken: kikAnonToken


module.exports = new User()
