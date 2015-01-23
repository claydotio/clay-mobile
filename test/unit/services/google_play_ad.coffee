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
      overrides =
        User:
          getExperiments: ->
            return Promise.resolve {}

      GooglePlayAdService.__with__(overrides) ->
        GooglePlayAdService.showAdModal()
        .then ->
          Modal.component.should.exist
          Modal.closeComponent()
          GooglePlayAdService.hasAdModalBeenShown = false

    it 'updates hasAdModalBeenShown', ->
      overrides =
        User:
          getExperiments: ->
            return Promise.resolve {}

      GooglePlayAdService.__with__(overrides) ->
        GooglePlayAdService.hasAdModalBeenShown.should.be.false
        GooglePlayAdService.showAdModal().then ->
          GooglePlayAdService.hasAdModalBeenShown.should.be.true
          GooglePlayAdService.hasAdModalBeenShown = false

  describe 'shouldShowAdModal', ->
    it 'visit 1, 5, 10, 20 -> true, others false', ->
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
            if _.contains [1, 5, 10, 20], visitCount
              shouldShow.should.be.true
            else
              shouldShow.should.be.false

    it 'only shows once per visit', ->
      visitCount = 0
      overrides =
        User:
          getExperiments: ->
            return Promise.resolve {}
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
            if visitCount is 1
              shouldShow.should.be.true
              GooglePlayAdService.showAdModal()
            else
              shouldShow.should.be.false
