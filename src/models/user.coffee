Q = require 'q'
log = require 'clay-loglevel'
z = require 'zorium'
_ = require 'lodash'

resource = require '../lib/resource'
config = require '../config'



resource.extendCollection 'users', (collection) ->
  me = if window._clay?.me
  then Q.resolve window._clay.me
  else collection.all('login').customPOST null, 'anon'

  # Save accessToken in cookie
  me = me.then (user) ->
    document.cookie = "accessToken=#{user.accessToken}"
    return user

  me.catch log.trace

  experiments = if window._clay?.experiments
  then Q.resolve window._clay.experiments
  else me.then (user) ->
    Q z.request
      url: config.FLAK_CANNON_PATH + '/experiments'
      method: 'POST'
      data:
        userId: user.id
      background: true

  experiments.catch log.trace

  collection.getMe = -> me

  collection.setMe = (_me) ->
    me = Q _me
    experiments = me.then (user) ->
      Q z.request
        url: config.FLAK_CANNON_PATH + '/experiments'
        method: 'POST'
        data:
          userId: user.id
        background: true
    return me

  collection.logEngagedActivity = ->
    me.then (me) ->
      Q.spread [
        collection.convertExperiment('engaged_activity').catch log.trace
        collection.all('me').customPOST null,
          'lastEngagedActivity',
          {accessToken: me.accessToken}
      ], (exp, res) ->
        res

  collection.getExperiments = -> experiments

  collection.setExperimentsFrom = (shareOriginUserId) ->
    experiments = me.then (user) ->
      Q z.request
        url: config.FLAK_CANNON_PATH + '/experiments'
        method: 'POST'
        data:
          fromUserId: shareOriginUserId
          userId: user.id
        background: true

  collection.convertExperiment = (event, {uniq} = {}) ->
    me.then (user) ->
      Q z.request
        url: config.FLAK_CANNON_PATH + '/conversions'
        method: 'POST'
        background: true
        data:
          event: event
          uniq: uniq
          userId: user.id

  collection.addRecentGame = (gameId) ->
    me.then (me) ->
      collection.all('me').customOperation 'patch', 'links/recentGames',
        {accessToken: me.accessToken},
        null,
        [
          op: 'add', path: '/-', value: gameId
        ]

  return collection


module.exports = resource.setBaseUrl(config.API_PATH).all('users')
