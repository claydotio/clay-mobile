EnvironmentService = require './environment'

# all methods should return promises for consistency
class FeaturesService
  shouldShowGooglePlayAds: ->
    platform = EnvironmentService.getPlatform()
    os = EnvironmentService.getOS()
    shouldShowGooglePlayAds = platform isnt 'native' and os is 'android'
    Promise.resolve shouldShowGooglePlayAds

module.exports = new FeaturesService()
