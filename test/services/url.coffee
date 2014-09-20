should = require('clay-chai').should()

MockGame = require '../_models/game'
UrlService = require 'services/url'
UrlService.constructor() # reset

urlRegex = require '../lib/url_regex'
# routes shouldn't have - or _
routeRegex = /^[a-zA-Z0-9\/]+$/

describe 'UrlService', ->
  describe 'State getters/setters', ->
    it 'getMarketplaceBase()', ->
      UrlService.getMarketplaceBase().should.match urlRegex

    it 'getMarketplaceGame({game})', ->
      UrlService.getMarketplaceGame({game: MockGame}).should.match urlRegex

    it 'getGameRoute({game}) (should be relative)', ->
      UrlService.getGameRoute({game: MockGame})
        .should.match routeRegex

    it 'getGameSubdomain({game})', ->
      UrlService.getGameSubdomain({game: MockGame})
        .should.match urlRegex

    it 'getGameSubdomain({game, protocol: "card:"}) is card:...', ->
      options = {game: MockGame, protocol: 'card:'}
      gameSubdomain = UrlService.getGameSubdomain(options)
      gameSubdomain.should.match urlRegex
      gameSubdomain.should.match /^card:/
