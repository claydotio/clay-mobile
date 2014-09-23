Q = require 'q'

localstore = require '../lib/localstore'
resource = require '../lib/resource'
config = require '../config'

resource.extendCollection 'users', (collection) ->
  me = null

  collection.getMe = ->
    if me
      return Q.when me

    localstore.get '/users/me'
    .then (_me) ->
      if _me
        return me = resource.setRestangularFields _me

      @customGET('me').then (_me) ->
        localstore.set '/users/me', _me
        .then ->
          me = _me

  collection.setMe = (_me) ->
    localstore.set '/users/me', _me
    .then ->
      me = resource.setRestangularFields _me

  return collection

module.exports = resource.setBaseUrl config.API_PATH
