z = require 'zorium'
_ = require 'lodash'
log = require 'clay-loglevel'
Q = require 'q'

User = require './user'
config = require '../config'


# TODO: (Zoli) Remove this in favor of putting it onto the user Object
class Experiment

  getFlakCannonUser = ->
    User.getMe().then (user) ->
      Q z.request
        url: config.FLAK_CANNON_PATH + '/users'
        method: 'POST'
        data:
          id: user.id


  constructor: ->
    @flakCannonUser = getFlakCannonUser()
      .catch log.trace

  getExperiments: =>
    @flakCannonUser.then (fcUser) ->
      fcUser.params

  convert: (event) =>
    fcRoot = config.FLAK_CANNON_PATH
    @flakCannonUser.then (fcUser) ->
      Q z.request
        url: "#{fcRoot}/users/#{fcUser.id}/convert/#{event}"
        method: 'POST'


module.exports = new Experiment()
