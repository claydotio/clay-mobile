should = require('clay-chai').should()
Joi = require 'joi'
Q = require 'q'

MockGame = require '../_models/game'
KikService = require 'services/kik'

urlRegex = require '../lib/url_regex'

describe 'KikService', ->

  it 'shareGame(game)', ->
    # Stub kik dependency
    KikService.__set__ 'kik',
      send: (options) ->
        schema = Joi.object().required().keys
          title: Joi.string().required()
          text: Joi.string().required()
          pic: Joi.string().regex(urlRegex).required()
          big: Joi.boolean()
          data: Joi.object().required().keys
            gameKey: Joi.string().valid(MockGame.key).required()
            share: Joi.object().required().keys
              originUserId: Joi.number().required()

        Joi.validate options, schema, (err, value) ->
          throw err if err

    KikService.shareGame(MockGame)
