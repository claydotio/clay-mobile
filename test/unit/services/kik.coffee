should = require('clay-chai').should()
Joi = require 'joi'
rewire = require 'rewire'

MockGame = require '../../_models/game'
KikService = rewire 'services/kik'

urlRegex = require '../../lib/url_regex'

describe 'KikService', ->

  describe 'isFromPush()', ->
    beforeEach ->
      KikService.constructor() # reset

    it 'is from push (true)', ->
      KikService.__set__ 'kik',
        push:
          handler: (cb) ->
            cb {}

      KikService.isFromPush().then (isFromPush) ->
        isFromPush.should.be.true

    it 'multiple successes', ->
      KikService.__set__ 'kik',
        push:
          handler: (cb) ->
            cb {}

      Promise.all [
        KikService.isFromPush().then (isFromPush) ->
          isFromPush.should.be.true
        KikService.isFromPush().then (isFromPush) ->
          isFromPush.should.be.true
      ]

    it 'is not from push (false)', ->
      KikService.__set__ 'kik',
        push:
          handler: (cb) ->
            # do nothing
            null

      KikService.isFromPush().then (isFromPush) ->
        isFromPush.should.be.false
