kik = require 'kik'

class EnvironmentService
  isAndroid: ->
    _.contains navigator.appVersion, 'Android'

  isClayApp: ->
    _.contains navigator.userAgent, 'Clay'

  isKik: ->
    Boolean kik?.enabled

module.exports = new EnvironmentService()
