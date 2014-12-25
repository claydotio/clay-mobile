Joi = require 'joi'
Flare = require 'flare-gun'
nock = require 'nock'
should = require('clay-chai').should()

app = require '../server'
config = require '../src/config'

flare = new Flare().express(app)
  .actor 'anon', {}

require('loglevel').disableAll()

ANON_USER_ID = 123
ANON_ACCESS_TOKEN = 'ANON_ACCESS_TOKEN'
ME_USER_ID = 321
ME_ACCESS_TOKEN = 'USER_ACCESS_TOKEN'

nock config.CLAY_API_URL
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
  .get '/healthcheck'
  .reply 200,
    healthy: true

nock config.FC_API_URL
  .persist()
  .post '/experiments'
  .reply 200,
    login_button: 'red'
  .get '/healthcheck'
  .reply 200,
    healthy: true

describe 'healthcheck', ->
  it 'is healthy', ->
    flare
      .get '/healthcheck'
      .expect 200,
        clayApi: true
        flakCannon: true
        healthy: true

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
      'window._clay={};' +
      'window._clay.me=' +
      "{\"id\":#{ANON_USER_ID},\"accessToken\":\"#{ANON_ACCESS_TOKEN}\"};"

    injectedUser =
      '<script>' +
      'window._clay={};' +
      'window._clay.me=' +
      "{\"id\":#{ME_USER_ID},\"accessToken\":\"#{ME_ACCESS_TOKEN}\"};"

    injectedNulls =
      '<script>window._clay={};window._clay.me=null;'

    describe 'anonymous user object if no auth_token cookie provided', ->
      it 'injects when host is root', ->
        flare
          .flare (flare) ->
            flare.request
              method: 'get'
              uri: flare.path + '/'
              headers:
                host: config.HOST
          .flare (flare) ->
            flare.res.body.should.contain injectedAnon
          .flare (flare) ->
            flare.request
              method: 'get'
              uri: flare.path + '/game/slime'
              headers:
                host: config.HOST
          .flare (flare) ->
            flare.res.body.should.contain injectedAnon

      it 'doesnt inject when host is subdomain', ->
        flare
          .as 'anon'
          .flare (flare) ->
            flare.request
              method: 'get'
              uri: flare.path + '/'
              headers:
                host: 'subdomain.clay.io'
          .flare (flare) ->
            flare.res.body.should.contain injectedNulls
          .flare (flare) ->
            flare.request
              method: 'get'
              uri: flare.path + '/game/slime'
              headers:
                host: 'subdomain.clay.io'
          .flare (flare) ->
            flare.res.body.should.contain injectedNulls

    it 'Does NOT Inject user provided in cookie', ->
      flare
        .actor 'joe',
          headers:
            'Cookie': "accessToken=#{ME_ACCESS_TOKEN}"
        .as 'joe'
        .get '/'
        .flare (flare) ->
          flare.res.body.should.not.contain injectedUser
        .get '/game/slime'
        .flare (flare) ->
          flare.res.body.should.not.contain injectedUser
    it 'Does NOT Inject anonymous user object if invalid token', ->
      flare
        .actor 'notjoe',
          headers:
            'Cookie': 'accessToken=INVALID_ACCESS_TOKEN'
        .as 'notjoe'
        .get '/'
        .flare (flare) ->
          flare.res.body.should.not.contain injectedAnon
        .get '/game/slime'
        .flare (flare) ->
          flare.res.body.should.not.contain injectedAnon

    it 'Does NOT Inject anonymous user if kik useragent', ->
      flare
        .actor 'kikUser',
          headers:
            host: config.HOST
            'User-Agent': 'Kik'
        .as 'kikUser'
        .get '/'
        .flare (flare) ->
          flare.res.body.should.not.contain injectedAnon
        .get '/game/slime'
        .flare (flare) ->
          flare.res.body.should.not.contain injectedAnon

  describe 'Experiments object injection', ->
    injectedExperiments = 'window._clay.experiments={"login_button":"red"}'

    it 'Injects a users experiments', ->
      flare
        .flare (flare) ->
          flare.request
            method: 'get'
            uri: flare.path + '/'
            headers:
              host: config.HOST
        .flare (flare) ->
          flare.res.body.should.contain injectedExperiments
        .flare (flare) ->
          flare.request
            method: 'get'
            uri: flare.path + '/game/slime'
            headers:
              host: config.HOST
        .flare (flare) ->
          flare.res.body.should.contain injectedExperiments
