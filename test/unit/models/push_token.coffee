should = require('clay-chai').should()
rewire = require 'rewire'
Zock = new (require 'zock')()

config = require 'config'
MockGame = require '../../_models/game'
PushToken = rewire 'models/push_token'
MockPushToken = require '../../_models/push_token'

MOCK_TOKEN = 'some_token'

describe 'PushToken', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  # reset localstorage after each test since we store a value that denotes
  # a token has been stored to prevent posting superfluously
  beforeEach ->
    localStorage.clear()

  describe 'Without Kik', ->
    before ->
      PushToken.__set__ 'kik', null

    it 'Attempts to create push token and promise rejects (no Kik)', ->
      PushToken.createByGameId MockGame.id
      .then ->
        throw new Error 'Expected error'
      , (err) ->
        err.message.should.be 'Kik not loaded - unable to get push token'

  describe 'With Kik', ->

    before ->
      PushToken.__set__ 'kik',
        ready: (fn) -> fn()
        push:
          getToken: (fn) -> fn MOCK_TOKEN

    it 'Attempts to create push token by gameId and resolves', ->
      Zock
        .base(config.PUBLIC_CLAY_API_URL)
        .post '/pushTokens'
        .reply 200, (res) ->
          res.body.gameId.should.be MockGame.id
          res.body.token.should.be MOCK_TOKEN
          return {gameId: res.body.gameId, token: res.body.token}

      PushToken.createByGameId MockGame.id

    it 'Attempts to create push token by gameKey and resolves', ->
      Zock
        .base(config.PUBLIC_CLAY_API_URL)
        .post '/pushTokens'
        .reply 200, (res) ->
          res.body.gameId.should.be MockGame.id
          res.body.token.should.be MOCK_TOKEN
          return {gameId: res.body.gameId, token: res.body.token}
        .get '/games/findOne'
        .reply 200, (res) ->
          return MockGame

      PushToken.createByGameKey MockGame.key

    it 'Attempts to create push token for marketplace and resolves', ->
      Zock
        .base(config.PUBLIC_CLAY_API_URL)
        .post '/pushTokens'
        .reply 200, (res) ->
          should.not.exist res.body.gameId
          res.body.token.should.be MOCK_TOKEN
          return {gameId: res.body.gameId, token: res.body.token}

      PushToken.createForMarketplace()

    it 'Attempts to create multiple push tokens', ->
      Zock
        .base(config.PUBLIC_CLAY_API_URL)
        .post '/pushTokens'
        .reply 200, (res) ->
          res.body.gameId.should.be MockGame.id
          res.body.token.should.be MOCK_TOKEN
          return {gameId: res.body.gameId, token: res.body.token}

      PushToken.createByGameId MockGame.id
      .then ->
        PushToken.createByGameId MockGame.id
