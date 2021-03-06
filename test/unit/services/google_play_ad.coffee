should = require('clay-chai').should()
rewire = require 'rewire'
Promise = require 'bluebird'

GooglePlayAdService = rewire 'services/google_play_ad'
Modal = require 'models/modal'

describe 'GooglePlayAdService', ->

  describe 'shouldShowAds', ->
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

  describe 'showAdModal', ->
    it 'opens modal', ->
      GooglePlayAdService.showAdModal()
      Modal.component.should.exist
      Modal.closeComponent()
      GooglePlayAdService.hasAdModalBeenShown = false

    it 'updates hasAdModalBeenShown', ->
      GooglePlayAdService.hasAdModalBeenShown.should.be.false
      GooglePlayAdService.showAdModal()
      GooglePlayAdService.hasAdModalBeenShown.should.be.true
      GooglePlayAdService.hasAdModalBeenShown = false

  describe 'shouldShowAdModal', ->
    it 'visit 2, 5, 10, 20 -> true, others false', ->
      visitCount = 0
      overrides =
      User:
        getVisitCount: ->
          return Promise.resolve visitCount
      EnvironmentService:
        isClayApp: ->
          return false
        isAndroid: ->
          return true

      Promise.each _.range(20), (newVisitCount) ->
        visitCount += 1
        GooglePlayAdService.__with__(overrides) ->
          GooglePlayAdService.shouldShowAdModal().then (shouldShow) ->
            if _.contains [2, 5, 10, 20], visitCount
              shouldShow.should.be.true
            else
              shouldShow.should.be.false

    it 'only shows once per visit', ->
      visitCount = 0
      overrides =
        User:
          getVisitCount: ->
            return Promise.resolve visitCount
        EnvironmentService:
          isClayApp: ->
            return false
          isAndroid: ->
            return true

      Promise.each _.range(20), (newVisitCount) ->
        visitCount += 1
        GooglePlayAdService.__with__(overrides) ->
          GooglePlayAdService.shouldShowAdModal().then (shouldShow) ->
            if visitCount is 2
              shouldShow.should.be.true
              GooglePlayAdService.showAdModal()
            else
              shouldShow.should.be.false
