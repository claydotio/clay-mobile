should = require('clay-chai').should()
rewire = require 'rewire'

GooglePlayAdService = rewire 'services/google_play_ad'

describe 'GooglePlayAdService', ->

  describe 'shouldShowGooglePlayAds', ->
    it 'not clay app, not android -> false', ->
      overrides =
        EnvironmentService:
          isClayApp: ->
            return false
          isAndroid: ->
            return false
      GooglePlayAdService.__with__(overrides) ->
        GooglePlayAdService.shouldShowAds().should.be.false

    it 'clay app, android -> false', ->
      overrides =
        EnvironmentService:
          isClayApp: ->
            return true
          isAndroid: ->
            return true
      GooglePlayAdService.__with__(overrides) ->
        GooglePlayAdService.shouldShowAds().should.be.false


    it 'not clay app, android -> true', ->
      overrides =
        EnvironmentService:
          isClayApp: ->
            return false
          isAndroid: ->
            return true
      GooglePlayAdService.__with__(overrides) ->
        GooglePlayAdService.shouldShowAds().should.be.true
