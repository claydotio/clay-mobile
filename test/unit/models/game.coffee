_ = require 'lodash'
should = require('clay-chai').should()

config = require 'config'
Game = require 'models/game'
localstore = require 'lib/localstore'
ZockService = require '../../_services/zock'
MockGame = require '../../_models/game'

describe 'Game', ->

  beforeEach ->
    localStorage.clear()

  it 'increments play count by 2', ->
    gameKey = MockGame.key
    Game.incrementPlayCount gameKey
    .then ->
      localstore.get "game:playCount:#{gameKey}"
    .then (gamePlayObject) ->
      gamePlayObject.count.should.be 1
      Game.incrementPlayCount gameKey
    .then ->
      localstore.get "game:playCount:#{gameKey}"
    .then (gamePlayObject) ->
      gamePlayObject.count.should.be 2

  it 'find()', ->
    ZockService
      .base(config.CLAY_API_URL)
      .get '/games'
      .reply 200, (res) ->
        res.query.ownerId.should.be '1'
        return MockGame

    Game.find({developerId: '1'}).then (response) ->
      response.should.be MockGame

  it 'get()', ->
    ZockService
      .base(config.CLAY_API_URL)
      .get '/games/1'
      .reply 200, (res) ->
        return MockGame

    Game.get('1').then (response) ->
      response.should.be MockGame

  it 'get() multiple games', ->
    ZockService
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
    MockGame.isStartComplete().should.be.true

  it 'isEditingComplete()', ->
    MockGame.isEditingComplete().should.be.true

  it 'isUploadComplete()', ->
    MockGame.isUploadComplete().should.be.true

  it 'isApprovable()', ->
    MockGame.isApprovable().should.be.true
