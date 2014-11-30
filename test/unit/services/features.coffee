should = require('clay-chai').should()
rewire = require 'rewire'

FeaturesService = rewire 'services/features'

describe 'FeaturesService', ->

  describe 'shouldShowGooglePlayAds', ->
    it 'kik, android -> true', ->
      FeaturesService.__set__ 'EnvironmentService.getPlatform', ->
        'kik'
      FeaturesService.__set__ 'EnvironmentService.getOS', ->
        'android'
      FeaturesService.shouldShowGooglePlayAds().then (shouldShow) ->
        shouldShow.should.be.true

    it 'native, android -> false', ->
      FeaturesService.__set__ 'EnvironmentService.getPlatform', ->
        'native'
      FeaturesService.__set__ 'EnvironmentService.getOS', ->
        'android'
      FeaturesService.shouldShowGooglePlayAds().then (shouldShow) ->
        shouldShow.should.be.false
