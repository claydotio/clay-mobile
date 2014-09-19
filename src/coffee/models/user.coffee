Q = require 'q'
z = require 'zorium' # TODO: (Zoli) replace with http lib
log = require 'loglevel'
localforage = require 'localforage'

config = require '../config'


# This is a stub until we have real user support.
# It is only depended on by the Experiment model.
class User
  constructor: ->
    @me = null

  getMe: =>
    unless @me
      if localStorage?['me']
        @me = JSON.parse localStorage['me']
        return Q.when @me
      else
        Q.when z.request
          method: 'POST'
          url: config.API_PATH + '/users'
        .then

      #   @me = {flakCannonId: localStorage['flakCannonId']}
      #   log.info 'found flak cannon id', @me
      #   return Q.when @me
      #
      # return Q.when z.request
      #   method: 'POST'
      #   url: config.FLAK_CANNON_PATH + '/users'
      # .then (flakCannonUser) =>
      #   localStorage['flakCannonId'] = flakCannonUser.id
      #   @me = {flakCannonId: flakCannonUser.id}
      #   log.info 'new flak cannon user', @me
      #   return @me

    return Q.when @me




module.exports = new User()
