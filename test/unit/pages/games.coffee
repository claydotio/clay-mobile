_ = require 'lodash'
should = require('clay-chai').should()
rewire = require 'rewire'

GamesPage = rewire 'pages/games'
Modal = require 'models/modal'

describe 'GamesPage', ->
  it 'shows google play modal only on 1st visit', ->

    localstoreCache = {}
    overrides =
      GooglePlayAdService:
        shouldShowAds: ->
          return true
      localstore:
        get: (key) ->
          Promise.resolve localstoreCache[key]

        set: (key, value) ->
          localstoreCache[key] = value
          Promise.resolve null

    GamesPage.__with__(overrides) ->
      GamesPageComponent = new GamesPage()
      GamesPageComponent.onMount()
      .then ->
        should.exist(Modal.component)
        Modal.closeComponent()
        GamesPageComponent = new GamesPage()
        GamesPageComponent.onMount()
      .then ->
        should.not.exist(Modal.component)
