Joi = require 'joi'
Flare = require 'flare-gun'
nock = require 'nock'
should = require('clay-chai').should()

app = require './server'

flare = new Flare().express(app)
  .actor 'anon', {}

require('loglevel').disableAll()

ANON_USER_ID = 123
ANON_ACCESS_TOKEN = 'ANON_ACCESS_TOKEN'
ME_USER_ID = 321
ME_ACCESS_TOKEN = 'USER_ACCESS_TOKEN'

nock 'http://clay.io'
  .persist()
  .get '/games/findOne?key=slime'
  .reply 200,
    id: 8
    key: 'slime'
    gameUrl: 'http://slime.clay.io'
    icon128Url: 'http://slime.clay.io'
    promo440Url: 'http://slime.clay.io'
    name: 'Slime'
    description: 'a game about slime'
    rating: 3
  .post '/users/login/anon'
  .reply 200,
    id: ANON_USER_ID
    accessToken: ANON_ACCESS_TOKEN
  .get '/users/me?accessToken=USER_ACCESS_TOKEN'
  .reply 200,
    id: ME_USER_ID
    accessToken: ME_ACCESS_TOKEN

describe 'index.dust', ->
  describe 'Basic page responses', ->
    before ->
      flare = flare.as 'anon'

    it 'Should include clay title', ->
      flare
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain '<title>Free Games</title>'
    it 'Should include game specific HTML', ->

      flare
        .get '/game/slime'
        .flare (flare) ->
          flare.res.body.should.contain '<title>Slime</title>'
    it 'Responds with clay title if game not found', ->
      flare
        .get '/game/NOT_A_VALID_GAME_KEY'
        .flare (flare) ->
          flare.res.body.should.contain '<title>Free Games</title>'

  describe 'User object injection', ->
    injectedAnon =
      '<script>' +
      'window._Clay={};' +
      'window._Clay.me=' +
      "{\"id\":#{ANON_USER_ID},\"accessToken\":\"#{ANON_ACCESS_TOKEN}\"};" +
      '</script>'

    injectedUser =
      '<script>' +
      'window._Clay={};' +
      'window._Clay.me=' +
      "{\"id\":#{ME_USER_ID},\"accessToken\":\"#{ME_ACCESS_TOKEN}\"};" +
      '</script>'

    it 'Injects anonymous user object if no auth_token cookie provided', ->
      flare
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain injectedAnon
        .get '/game/slime'
        .flare (flare) ->
          flare.res.body.should.contain injectedAnon

    it 'Injects user provided in cookie', ->
      flare
        .actor 'joe',
          headers:
            'Cookie': "accessToken=#{ME_ACCESS_TOKEN}"
        .as 'joe'
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain injectedUser
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain injectedUser
    it 'Injects anonymous user object if invalid token', ->
      flare
        .actor 'notjoe',
          headers:
            'Cookie': 'accessToken=INVALID_ACCESS_TOKEN'
        .as 'notjoe'
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain injectedAnon
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain injectedAnon

  # Warning, mocked routes are disabled from here on
  describe 'graceful degredation', ->
    before ->
      nock.restore()

    it 'Injects null if anonymous user request fails', ->
      # Let request time out
      @timeout(5000)

      injectedNull =
        '<script>' +
        'window._Clay={};' +
        'window._Clay.me=null;' +
        '</script>'

      flare
        .as 'anon'
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain injectedNull
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain injectedNull
