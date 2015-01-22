_ = require 'lodash'
should = require('clay-chai').should()
rewire = require 'rewire'

GamesPage = rewire 'pages/games'
Modal = require 'models/modal'

describe 'GamesPage', ->
  it 'shows google play modal when shouldShowAdModal', ->
    adModalVisible = false
    overrides =
      GooglePlayAdService:
        shouldShowAdModal: ->
          Promise.resolve true
        shouldShowAds: ->
          return true
        showAdModal: ->
          adModalVisible = true

    GamesPage.__with__(overrides) ->
      GamesPageComponent = new GamesPage()
      GamesPageComponent.googlePlayAdModalPromise
      .then ->
        adModalVisible.should.be.true

  it 'doesn\'t show google play modal when not shouldShowAdModal', ->
    overrides =
      GooglePlayAdService:
        shouldShowAdModal: ->
          Promise.resolve false
        shouldShowAds: ->
          return true

    GamesPage.__with__(overrides) ->
      GamesPageComponent = new GamesPage()
      GamesPageComponent.googlePlayAdModalPromise
      .then ->
        should.not.exist Modal.component
