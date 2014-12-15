Joi = require 'joi'
log = require 'clay-loglevel'
Zock = require 'zock'

config = require 'config'
ErrorReportService = require 'services/error_report'

describe 'ErrorReportService', ->

  it 'report()', (done) ->
    mock = new Zock()
      .base(config.CLAY_API_URL)
      .logger log.info
      .post '/log'
      .reply 200, (res) ->
        schema = Joi.object().keys
          message: Joi.string().regex /terrible/

        Joi.validate res.body, schema, (err) ->
          window.XMLHttpRequest = originalXMLHttpRequestFn
          done err

    originalXMLHttpRequestFn = window.XMLHttpRequest
    window.XMLHttpRequest = ->
      mock.XMLHttpRequest()

    err = new Error 'terrible'
    ErrorReportService.report err
