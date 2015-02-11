should = require('clay-chai').should()
Zock = new (require 'zock')()

config = require 'config'
User = require 'models/user'
MockUser = require '../../_models/user'

describe 'UserModel', ->

  before ->
    window.XMLHttpRequest = ->
      Zock.XMLHttpRequest()

    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/users/login/anon'
      .reply 200, (res) ->
        return MockUser

  describe 'getMe()', ->
    it 'returns cached local user', ->
      User.setMe Promise.resolve {id: 123, username: 'tester'}
      .then (user) ->
        user.id.should.be 123
        user.username.should.be 'tester'

        User.getMe()
        .then (sameUser) ->
          sameUser.should.be user

  describe 'setMe', ->
    it 'updates existing `me` observable', ->
      User.setMe Promise.resolve {id: 123, username: 'tester'}
      .then (user) ->
        User.setMe Promise.resolve {id: 321, username: 'retset'}
        .then (differentUser) ->
          differentUser.id.should.not.equal user.id


  it 'loginBasic()', ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/users/login/basic'
      .reply 200, (res) ->
        res.query.accessToken.should.be 'ACCESS_TOKEN' and
        res.body.email.should.be 'hi@ho.com'
        res.body.password.should.be 'secret'
        return MockUser

    User.loginBasic({email: 'hi@ho.com', password: 'secret'})
    .then (response) ->
      response.should.be MockUser

  it 'loginPhone()', ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/users/login/phone'
      .reply 200, (res) ->
        res.query.accessToken.should.be 'ACCESS_TOKEN' and
        res.body.phone.should.be MockUser.phone
        res.body.password.should.be 'secret'
        return MockUser

    User.loginPhone({phone: MockUser.phone, password: 'secret'})
    .then (response) ->
      response.should.be MockUser

  it 'recoverLogin()', ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/users/login/recovery'
      .reply 200, (res) ->
        res.query.accessToken.should.be 'ACCESS_TOKEN' and
        res.body.phone.should.be MockUser.phone
        return MockUser

    User.recoverLogin({phone: MockUser.phone})
    .then (response) ->
      response.should.be MockUser

  it 'isLoggedIn()', ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/users/login/phone'
      .reply 200, (res) ->
        res.query.accessToken.should.be 'ACCESS_TOKEN' and
        res.body.phone.should.be MockUser.phone
        return MockUser

    User.setMe(User.loginPhone({phone: MockUser.phone, password: 'secret'}))
    .then ->
      User.isLoggedIn().then (isLoggedIn) ->
        isLoggedIn.should.be true

  it 'addFriend()', ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .post '/users/me/friends'
      .reply 200, (res) ->
        res.query.accessToken.should.be 'ACCESS_TOKEN' and
        res.body.userId.should.be MockUser.id
        return MockUser

    User.addFriend MockUser.id
    .then (response) ->
      response.should.be MockUser

  it 'getFriends()', ->
    Zock
      .base(config.PUBLIC_CLAY_API_URL)
      .get '/users/me/friends'
      .reply 200, (res) ->
        return [MockUser]

    User.getFriends()
    .then (response) ->
      response.should.be [MockUser]
