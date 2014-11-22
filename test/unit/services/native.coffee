should = require('clay-chai').should()
rewire = require 'rewire'

MockGame = require '../../_models/game'
NativeService = rewire 'services/native'

describe 'NativeService', ->
  after ->
    # FIXME: remove when we have impact hammer
    window.removeEventListener 'message', NativeService.onMessage

  describe 'Validate', ->
    after ->
      # hacky, code is going to be killed
      NativeService.validateParent = ->
        Promise.resolve true

    it 'validateParent()', (done) ->

      NativeService.__set__ 'window.parent.postMessage',
        (messageString, targetOrigin) ->
          targetOrigin.should.be '*'
          message = JSON.parse messageString
          message.id.should.be.a.Number
          message._clay.should.be true
          message.jsonrpc.should.be '2.0'

          message.method.should.be 'ping'

          done()

      NativeService.validateParent()

  describe 'share', ->

    it 'shareGame(game)', (done) ->

      NativeService.__set__ 'window.parent.postMessage',
        (messageString, targetOrigin) ->
          targetOrigin.should.be '*'
          message = JSON.parse messageString
          message.id.should.be.a.Number
          message._clay.should.be true
          message.jsonrpc.should.be '2.0'

          message.method.should.be 'share.all'

          # no callback for share.all
          done()

      NativeService.shareGame(MockGame)

    it 'shareMarketplace()', (done) ->

      NativeService.__set__ 'window.parent.postMessage',
        (messageString, targetOrigin) ->
          targetOrigin.should.be '*'
          message = JSON.parse messageString
          message.id.should.be.a.Number
          message._clay.should.be true
          message.jsonrpc.should.be '2.0'

          message.method.should.be 'share.all'

          # no callback for share.all
          done()

      NativeService.shareMarketplace()
