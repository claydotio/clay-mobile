Joi = require 'joi'
log = require 'clay-loglevel'

config = require 'config'
ErrorReportService = require 'services/error_report'
ZockService = require '../../_services/zock'

describe 'ErrorReportService', ->

  it 'report()', (done) ->
    ZockService
      .base(config.CLAY_API_URL)
      .post '/log'
      .reply 200, (res) ->
        schema = Joi.object().keys
          message: Joi.string()

        Joi.validate res.body, schema, {presence: 'required'}, (err) ->
          done err

    ErrorReportService.report new Error()
