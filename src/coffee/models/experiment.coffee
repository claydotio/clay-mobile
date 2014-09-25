reqwest = require 'reqwest'
_ = require 'lodash'
log = require 'loglevel'

User = require './user'
config = require '../config'

getFlakCannonUser = ->
  User.getMe().then (user) ->
    reqwest
      url: config.FLAK_CANNON_PATH + '/users'
      method: 'POST'
      data:
        id: user.id

class Experiment

  constructor: ->
    @flakCannonUser = getFlakCannonUser()
      .catch log.trace

  getExperiments: ->
    @flakCannonUser.then (fcUser) ->
      fcUser.params

  convert: (event) ->
    fcRoot = config.FLAK_CANNON_PATH
    @flakCannonUser.then (fcUser) ->
      reqwest
        url: "#{fcRoot}/users/#{fcUser.id}/convert/#{event}"
        method: 'POST'


module.exports = new Experiment()
