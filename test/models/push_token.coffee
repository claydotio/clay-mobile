should = require('clay-chai').should()


MockGame = require '../_models/game'
PushToken = require 'models/push_token'

describe 'PushToken', ->
  describe 'Without Kik', ->
    before ->
      # Stub kik dependency
      PushToken.__set__ 'kik', null

    it 'Attempts to create push token and promise rejects (no Kik)', ->
      PushToken.all('pushTokens').createByGameId MockGame.id
      .then ->
        throw new Error 'Expected error'
      , (err) ->
        err.message.should.be 'Kik not loaded - unable to get push token'

  describe 'With Kik', ->

    before ->
      # Stub kik dependency
      PushToken.__set__ 'kik',
        ready: (fn) -> fn()
        push:
          getToken: (fn) -> fn 'fake_token'

    # reset localstorage after each test since we store a value that denotes
    # a token has been stored to prevent posting superfluously
    afterEach ->
      localStorage.clear()

    it 'Attempts to create push token by gameId and resolves', ->
      PushToken.all('pushTokens').createByGameId MockGame.id

    it 'Attempts to create push token by gameKey and resolves', ->
      PushToken.all('pushTokens').createByGameKey MockGame.key

    it 'Attempts to create push token for marketplace and resolves', ->
      PushToken.all('pushTokens').createForMarketplace()

    it 'Attempts to create multiple push tokens and fails', ->
      PushToken.all('pushTokens').createByGameId MockGame.id
      .then ->
        PushToken.all('pushTokens').createByGameId MockGame.id
      .then ->
        throw new Error 'Expected error'
      , (err) ->
        err.message.should.be 'Token already created'
