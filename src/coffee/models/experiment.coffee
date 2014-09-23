z = require 'zorium' # TODO: (Zoli) replace with http lib
_ = require 'lodash'
log = require 'loglevel'

User = require './user'
config = require '../config'

# FIXME: BROKEN
Q = require 'q'

class Experiment
  constructor: ->
    @experiments = {}

  getExperiments: ->
    # FIXME: BROKEN
    Q.when {}
    # User.getMe().then (user) =>
    #   z.request
    #     method: 'GET'
    #     url: config.FLAK_CANNON_PATH + '/users/' + user.flakCannonId
    #   .then (flakCannonUser) =>
    #     _.defaults @overrides(), flakCannonUser.params

  convert: (event) ->
    # FIXME: BROKEN
    Q.when null

    # fcRoot = config.FLAK_CANNON_PATH
    # User.getMe().then (user) ->
    #   z.request
    #     method: 'POST'
    #     url: "#{fcRoot}/users/#{user.flakCannonId}/convert/#{event}"
    # .catch log.trace

module.exports = new Experiment()
