should = require('clay-chai').should()
rewire = require 'rewire'

GooglePlayAdService = rewire 'services/google_play_ad'

describe 'GooglePlayAdService', ->

  describe 'shouldShowGooglePlayAds', ->
    it 'not clay app, not android -> false', ->
      GooglePlayAdService.__set__ 'EnvironmentService.isClayApp', ->
        return false
      GooglePlayAdService.__set__ 'EnvironmentService.isAndroid', ->
        return false

      GooglePlayAdService.shouldShowAds().should.be.false

    it 'clay app, android -> false', ->
      GooglePlayAdService.__set__ 'EnvironmentService.isClayApp', ->
        return true
      GooglePlayAdService.__set__ 'EnvironmentService.isAndroid', ->
        return true

      GooglePlayAdService.shouldShowAds().should.be.false


    it 'not clay app, android -> true', ->
      GooglePlayAdService.__set__ 'EnvironmentService.isClayApp', ->
        return false
      GooglePlayAdService.__set__ 'EnvironmentService.isAndroid', ->
        return true

      GooglePlayAdService.shouldShowAds().should.be.true
