Joi = require 'joi'
Flare = require 'flare-gun'
nock = require 'nock'
should = require('clay-chai').should()

app = require '../server'
config = require '../src/config'
MockGame = require './_models/game'

flare = new Flare().express(app)
  .actor 'anon', {}
  .actor 'kik', {
    headers:
      'user-agent': 'KikBot'
  }

require('loglevel').disableAll()

ANON_USER_ID = 123
ANON_ACCESS_TOKEN = 'ANON_ACCESS_TOKEN'
ME_USER_ID = 321
ME_ACCESS_TOKEN = 'USER_ACCESS_TOKEN'

nock config.CLAY_API_URL
  .persist()
  .get "/games/findOne?key=#{MockGame.key}"
  .reply 200, MockGame
  .get '/games/findOne?key=NOT_A_VALID_GAME_KEY'
  .reply 200, []
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
  .get '/ping'
  .reply 200,
    'pong'

nock config.FC_API_URL
  .persist()
  .post '/experiments'
  .reply 200,
    login_button: 'red'
  .get '/ping'
  .reply 200,
    'pong'

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
          flare.res.body.should.contain \
            '<title>Clay Games - Play Free HTML5 Mobile Games</title>'

    it 'Should include game specific HTML', ->
      flare
        .get "/game/#{MockGame.key}"
        .flare (flare) ->
          flare.res.body.should.contain \
            "<title>#{MockGame.name} - Clay Games Mobile HTML5</title>"

    it 'Responds with 404 if game not found', ->
      flare
        .get '/game/NOT_A_VALID_GAME_KEY'
        .expect 404
        .flare (flare) ->
          flare.res.body.should.contain \
            '<title>Game not found - Clay Games</title>'

  describe 'Kik page responses', ->
    before ->
      flare = flare.as 'kik'

    it 'Should include clay title', ->
      flare
        .get '/'
        .flare (flare) ->
          flare.res.body.should.contain '<title>Free Games</title>'

    it 'Should include icon without protocol', ->
      flare
        .get "/game/#{MockGame.key}"
        .flare (flare) ->
          iconUrl = MockGame.iconImage.versions[0].url.replace /^https?:/, ''
          flare.res.body.should.contain \
            "<link rel=\"kik-icon\" href=\"#{iconUrl}\">"

    it 'Should include game specific HTML', ->
      flare
        .get "/game/#{MockGame.key}"
        .flare (flare) ->
          flare.res.body.should.contain "<title>#{MockGame.name}</title>"

    it 'Responds with 404 if game not found', ->
      flare
        .get '/game/NOT_A_VALID_GAME_KEY'
        .expect 404
        .flare (flare) ->
          flare.res.body.should.contain \
            '<title>Game not found - Clay Games</title>'
