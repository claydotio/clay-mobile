should = require('clay-chai').should()
rewire = require 'rewire'

MockGame = require '../../_models/game'
UrlService = rewire 'services/url'
UrlService.constructor() # reset

urlRegex = require '../../lib/url_regex'
# routes shouldn't have - or _
routeRegex = /^[a-zA-Z0-9\/]+$/

describe 'UrlService', ->

  it 'getMarketplaceBase()', ->
    UrlService.getMarketplaceBase().should.match urlRegex

  it 'getMarketplaceBase({protocol: "card"}) is card...', ->
    marketplaceBaseUrl = UrlService.getMarketplaceBase({protocol: 'card'})
    marketplaceBaseUrl.should.match urlRegex
    marketplaceBaseUrl.should.match /^card:/

  it 'getMarketplaceGame({game})', ->
    UrlService.getMarketplaceGame({game: MockGame}).should.match urlRegex

  it 'getMarketplaceGame({protocol: "card"}) is card...', ->
    options = {game: MockGame, protocol: 'card'}
    marketplaceGameUrl = UrlService.getMarketplaceGame(options)
    marketplaceGameUrl.should.match urlRegex
    marketplaceGameUrl.should.match /^card:/

  it 'getGameRoute({game}) (should be relative)', ->
    UrlService.getGameRoute({game: MockGame})
      .should.match routeRegex

  it 'getGameSubdomain({game})', ->
    UrlService.getGameSubdomain({game: MockGame})
      .should.match urlRegex

  it 'getGameSubdomain({game, protocol: "card"}) is card...', ->
    options = {game: MockGame, protocol: 'card'}
    gameSubdomain = UrlService.getGameSubdomain(options)
    gameSubdomain.should.match urlRegex
    gameSubdomain.should.match /^card:/

  it 'getSubdomain() when window.location.host is slime.clay.io', ->
    UrlService.__set__ 'host', 'slime.clay.io'
    UrlService.getSubdomain().should.be 'slime'

  it 'getSubdomain() when window.location.host is clay.io ', ->
    UrlService.__set__ 'host', 'clay.io'
    should.not.exist UrlService.getSubdomain()

  it 'getSubdomain({url: "http://slime.clay.io"})', ->
    testUrl = 'http://slime.clay.io'
    UrlService.getSubdomain({url: testUrl}).should.be 'slime'

  it 'getSubdomain({url: "clay.io"})', ->
    testUrl = 'clay.io'
    should.not.exist UrlService.getSubdomain({url: testUrl})

  it 'getSubdomain({url: "test"})', ->
    testUrl = 'test'
    should.not.exist UrlService.getSubdomain({url: testUrl})

  it 'openWindow() kik', (done) ->
    overrides =
      kik:
        open: (url) ->
          url.should.be 'http://clay.io'
          done()

      EnvironmentService:
        isKikEnabled: ->
          return true
        isClayApp: ->
          return false

    UrlService.__with__(overrides) ->
      UrlService.openWindow 'http://clay.io'

  it 'openWindow() Clay App', (done) ->
    oldOpen = window.open
    window.open = (url, windowName) ->
      window.open = oldOpen
      url.should.be 'http://clay.io'
      windowName.should.be '_system'
      done()

    overrides =
      EnvironmentService:
        isKikEnabled: ->
          return false
        isClayApp: ->
          return true

    UrlService.__with__(overrides) ->
      UrlService.openWindow 'http://clay.io'

  it 'openWindow()', (done) ->
    oldOpen = window.open
    window.open = (url, windowName) ->
      window.open = oldOpen
      url.should.be 'http://clay.io'
      windowName.should.be '_blank'
      done()

    UrlService.openWindow 'http://clay.io'
