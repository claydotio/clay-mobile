Joi = require 'joi'
log = require 'clay-loglevel'
Zock = new (require 'zock')()

config = require 'config'
ErrorReportService = require 'services/error_report'

describe 'ErrorReportService', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  it 'report()', (done) ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/log'
      .reply 200, (res) ->
        schema = Joi.object().keys
          message: Joi.string()

        Joi.validate res.body, schema, {presence: 'required'}, (err) ->
          done err

    ErrorReportService.report new Error('err')
