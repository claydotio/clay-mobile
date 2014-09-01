z = require 'zorium' # TODO: (Zoli) replace with http lib
_ = require 'lodash'
log = require 'loglevel'

User = require './user'
config = require '../config'

class Experiment
  constructor: ->
    @experiments = {}

  getExperiments: =>
    User.getMe().then (user) =>
      z.request
        method: 'GET'
        url: config.FLAK_CANNON_PATH + '/users/' + user.flakCannonId
      .then (flakCannonUser) =>
        _.defaults @overrides(), flakCannonUser.params

  convert: (event) ->
    fcRoot = config.FLAK_CANNON_PATH
    User.getMe().then (user) ->
      z.request
        method: 'POST'
        url: "#{fcRoot}/users/#{user.flakCannonId}/convert/#{event}"
    .catch log.trace

  # Temporary testing overrides for debugging.
  # TODO: (Zoli) remove in favor of user auth overrides.
  overrides: ->
    if localStorage['fcOverride']
      try
        return JSON.parse localStorage['fcOverride']
      catch err
        console.error err
    return {}

  setExperiment: (key, value) =>
    @experiments[key] = value


module.exports = new Experiment()
