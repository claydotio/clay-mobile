Q = require 'q'
log = require 'clay-loglevel'

resource = require '../lib/resource'
config = require '../config'


resource.extendCollection 'users', (collection) ->
  me = collection.all('login').customPOST null, 'anon'
    .catch log.trace

  collection.getMe = ->
    me

  collection.setMe = (_me) ->
    me = Q _me

  return collection


module.exports = resource.setBaseUrl(config.API_PATH).all('users')
