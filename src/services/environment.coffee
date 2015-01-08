class EnvironmentService
  isAndroid: ->
    _.contains navigator.appVersion, 'Android'

  isClayApp: ->
    _.contains navigator.userAgent, 'Clay'

module.exports = new EnvironmentService()
