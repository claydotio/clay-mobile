Q = require 'q'
log = require 'clay-loglevel'

resource = require '../lib/resource'
config = require '../config'



resource.extendCollection 'users', (collection) ->
  me = if window._Clay?.me
  then Q.resolve window._Clay.me
  else collection.all('login').customPOST null, 'anon'

  # Save accessToken in cookie
  me = me.then (user) ->
    document.cookie = "accessToken=#{user.accessToken}"

  me.catch log.trace

  collection.getMe = ->
    me

  collection.setMe = (_me) ->
    me = Q _me

  collection.logEngagedActivity = ->
    me.then (me) ->
      # TODO: (Zoli) remove after merging experiment and user model
      # WARNING: This is a circular dependency
      Experiment = require './experiment'
      Q.spread [
        Experiment.convert('engaged_activity').catch log.trace
        collection.all('me').customPOST null,
          'lastEngagedActivity',
          {accessToken: me.accessToken}
      ], (exp, res) ->
        res

  return collection


module.exports = resource.setBaseUrl(config.API_PATH).all('users')
