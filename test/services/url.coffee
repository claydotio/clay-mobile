should = require('clay-chai').should()

urlRegex = require '../lib/url_regex'
UrlService = require 'services/url'
UrlService.constructor() # reset

describe 'UrlService', ->
  describe 'State getters/setters', ->
    it 'getMarketplaceBase()', ->
      UrlService.getMarketplaceBase().should.match urlRegex

    it 'getMarketplaceGame()', ->
      UrlService.getMarketplaceGame().should.match urlRegex
