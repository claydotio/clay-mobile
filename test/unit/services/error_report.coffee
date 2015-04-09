Joi = require 'joi'
log = require 'clay-loglevel'
Zock = new (require 'zock')()
should = require('clay-chai').should()

config = require 'config'
ErrorReportService = require 'services/error_report'

describe 'ErrorReportService', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  it 'reports error', (done) ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/log'
      .reply 200, (res) ->
        _.includes(res.body.message, 'abc').should.be true
        Joi.validate res.body,
          Joi.object().keys(
            message: Joi.string()
          )
        , {presence: 'required'}, done

    ErrorReportService.report new Error('abc')

  it 'reports multiple errors', (done) ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/log'
      .reply 200, (res) ->
        _.includes(res.body.message, 'abc1').should.be true
        _.includes(res.body.message, 'abc2').should.be true
        Joi.validate res.body,
          Joi.object().keys(
            message: Joi.string()
          )
        , {presence: 'required'}, done

    ErrorReportService.report new Error('abc1'), new Error('abc2')
