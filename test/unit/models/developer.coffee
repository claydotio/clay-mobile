should = require('clay-chai').should()
Zock = new (require 'zock')()

config = require 'config'
Developer = require 'models/developer'
MockDeveloper = require '../../_models/developer'

describe 'Developer', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  it 'find()', ->
    Zock
      .base(config.CLAY_API_URL)
      .get '/developers'
      .reply 200, (res) ->
        res.query.ownerId.should.be '1'
        return MockDeveloper

    Developer.find({ownerId: '1'}).then (response) ->
      response.should.be MockDeveloper

  it 'create()', ->
    Zock
      .base(config.CLAY_API_URL)
      .post '/users/login/anon'
      .reply 200, {accessToken: 'ACCESS_TOKEN'}
      .post '/developers'
      .reply 200, (res) ->
        res.query.accessToken.should.be 'ACCESS_TOKEN'
        return MockDeveloper

    Developer.create().then (response) ->
      response.should.be MockDeveloper
