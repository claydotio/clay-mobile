Q = require 'q'
log = require 'loglevel'

resource = require '../lib/resource'
config = require '../config'


resource.extendCollection 'users', (collection) ->
  me = collection.customGET('me')

  collection.getMe = ->
    me

  collection.setMe = (_me) ->
    me = Q _me

  return collection

module.exports = resource.setBaseUrl(config.API_PATH).all('users')
