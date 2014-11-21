log = require 'clay-loglevel'
_ = require 'lodash'

request = require '../lib/request'
config = require '../config'

PATH = config.API_PATH + '/users'

me = null
experiments = null

class User

  getMe: ->
    unless me
      me = if window._clay?.me
      then Promise.resolve window._clay.me
      else request PATH + '/login/anon',
        method: 'POST'

      # Save accessToken in cookie
      me.then (user) ->
        document.cookie = "accessToken=#{user.accessToken}"
      .catch log.trace

    return me

  setMe: (_me) ->
    me = Promise.resolve _me
    experiments = me.then (user) ->
      request config.FLAK_CANNON_PATH + '/experiments',
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
        request config.FLAK_CANNON_PATH + '/experiments',
          method: 'POST'
          body:
            userId: user.id

    return experiments

  setExperimentsFrom: (shareOriginUserId) =>
    experiments = @getMe().then (user) ->
      request config.FLAK_CANNON_PATH + '/experiments',
        method: 'POST'
        body:
          fromUserId: shareOriginUserId
          userId: user.id

  convertExperiment: (event, {uniq} = {}) =>
    @getMe().then (user) ->
      request config.FLAK_CANNON_PATH + '/conversions',
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
          {accessToken: me.accessToken}
        body:
          [ op: 'add', path: '/-', value: gameId ]


module.exports = new User()
