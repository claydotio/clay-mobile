Q = require 'q'
log = require 'clay-loglevel'
z = require 'zorium'

resource = require '../lib/resource'
config = require '../config'



resource.extendCollection 'users', (collection) ->
  me = if window._Clay?.me
  then Q.resolve window._Clay.me
  else collection.all('login').customPOST null, 'anon'

  # Save accessToken in cookie
  me = me.then (user) ->
    document.cookie = "accessToken=#{user.accessToken}"
    return user

  me.catch log.trace

  experiments = me.then (user) ->
    Q z.request
      url: config.FLAK_CANNON_PATH + '/experiments'
      method: 'POST'
      data:
        id: user.id
  .catch log.trace

  collection.getMe = ->
    me

  collection.setMe = (_me) ->
    me = Q _me

  collection.logEngagedActivity = ->
    me.then (me) ->
      Q.spread [
        collection.convertExperiment('engaged_activity').catch log.trace
        collection.all('me').customPOST null,
          'lastEngagedActivity',
          {accessToken: me.accessToken}
      ], (exp, res) ->
        res

  collection.getExperiments = ->
    return experiments

  collection.convertExperiment = (event) ->
    me.then (user) ->
      Q z.request
        url: config.FLAK_CANNON_PATH + '/conversions'
        method: 'POST'
        data:
          event: event
          data:
            id: user.id

  return collection


module.exports = resource.setBaseUrl(config.API_PATH).all('users')
