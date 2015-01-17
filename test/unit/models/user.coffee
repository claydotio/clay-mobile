should = require('clay-chai').should()
Zock = new (require 'zock')()

config = require 'config'
User = require 'models/user'
MockUser = require '../../_models/user'

describe 'UserModel', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

  it 'returns cached local user', ->
    User.setMe {id: 123, username: 'tester'}
    .then (user) ->
      user.id.should.be 123
      user.username.should.be 'tester'

      User.getMe()
      .then (sameUser) ->
        sameUser.should.be user

  it 'loginBasic()', ->
    Zock
      .base(config.CLAY_API_URL)
      .post '/users/login/basic'
      .reply 200, (res) ->
        res.query.accessToken.should.be 'ACCESS_TOKEN' and
        res.body.email.should.be 'hi@ho.com'
        res.body.password.should.be 'secret'
        return MockUser

    User.loginBasic({email: 'hi@ho.com', password: 'secret'})
    .then (response) ->
      response.should.be MockUser
