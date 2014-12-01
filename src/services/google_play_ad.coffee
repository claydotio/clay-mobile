EnvironmentService = require './environment'

# all methods should return promises for consistency
class GooglePlayAdService
  shouldShowAds: ->
    return EnvironmentService.isAndroid() and
           not EnvironmentService.isClayApp()

module.exports = new GooglePlayAdService()
