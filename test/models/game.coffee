should = require('clay-chai').should()

Game = require 'models/game'
localstore = require 'lib/localstore'

MockGame = require '../_models/game'

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
