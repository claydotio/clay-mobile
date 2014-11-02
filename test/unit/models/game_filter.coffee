should = require('clay-chai').should()

GameFilter = require 'models/game_filter'
GameFilter.constructor() # reset

describe 'GameFilterModel', ->
  describe 'State getters/setters', ->
    it 'begins with top label', ->
      GameFilter.getFilter().should.be 'top'

    it 'setFilter()', ->
      GameFilter.setFilter('test').should.be 'test'

    it 'getFilter(), with new state', ->
      GameFilter.getFilter().should.be 'test'
