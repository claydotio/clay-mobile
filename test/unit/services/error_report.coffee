should = require('clay-chai').should()
Joi = require 'joi'
rewire = require 'rewire'
Promise = require 'bluebird'

ErrorReportService = rewire 'services/error_report'

describe 'ErrorReportService', ->

  it 'report()', (done) ->
    fetchClone = window.fetch
    window.fetch = (url, options) ->
      schema = Joi.object().required().keys
        method: Joi.string().valid 'POST'
        headers: Joi.object().required().keys
          'Accept':
            Joi.string().required().valid 'application/json'
          'Content-Type':
            Joi.string().valid 'application/json'
        body:
          Joi.string()

      Joi.validate options, schema, (err) ->
        window.fetch = fetchClone
        done err

    err = new Error()
    ErrorReportService.report err
