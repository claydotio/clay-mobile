_ = require 'lodash'
should = require('clay-chai').should()
Zock = new (require 'zock')()

config = require 'config'
Game = require 'models/game'
localstore = require 'lib/localstore'
MockGame = require '../../_models/game'

describe 'Game', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  it 'increments play count by 2', ->
    gameKey = MockGame.key
    Game.incrementPlayCount gameKey
    .then (newPlayCount) ->
      newPlayCount.should.be 1
      Game.incrementPlayCount gameKey
    .then (newPlayCount) ->
      newPlayCount.should.be 2

  it 'find()', ->
    Zock
      .base(config.CLAY_API_URL)
      .get '/games'
      .reply 200, (res) ->
        res.query.developerId.should.be '1'
        return MockGame

    Game.find({developerId: '1'}).then (response) ->
      response.should.be MockGame

  it 'get()', ->
    Zock
      .base(config.CLAY_API_URL)
      .get "/games/#{MockGame.id}"
      .reply 200, (res) ->
        return MockGame

    Game.get('1').then (response) ->
      response.should.be MockGame

  it 'get() multiple games', ->
    Zock
      .base(config.CLAY_API_URL)
      .get '/games/1,2'
      .reply 200, (res) ->
        return [MockGame, MockGame]

    Game.get('1,2').then (response) ->
      response.should.be [MockGame, MockGame]

  it 'setEditingGame()', ->
    Game.setEditingGame Promise.resolve MockGame
    Game.getEditingGame().then (game) ->
      game.should.be MockGame

  it 'updateEditingGame()', ->
    Game.setEditingGame Promise.resolve MockGame
    Game.updateEditingGame {name: 'Modified name'}
    Game.getEditingGame().then (game) ->
      modifiedGame = _.cloneDeep MockGame
      modifiedGame.name = 'Modified name'
      game.should.be modifiedGame

  it 'isStartComplete()', ->
    Game.isStartComplete(MockGame).should.be.true

  it 'isDetailsComplete()', ->
    Game.isDetailsComplete(MockGame).should.be.true

  it 'isUploadComplete()', ->
    Game.isUploadComplete(MockGame).should.be.true

  it 'isApprovable()', ->
    Game.isApprovable(MockGame).should.be.true
