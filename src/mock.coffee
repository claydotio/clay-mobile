_ = require 'lodash'
Zock = require 'zock'
log = require 'clay-loglevel'

config = require './config'

game = (i, isNew) ->
  title = "game #{i}"

  # Prefix new games titles
  if isNew
    title = 'new ' + title

  # Every 5th game has a long title
  if i % 5 is 0
    title += ' with a really long title that is here'

  id: i
  key: i
  gameUrl: 'http://cdn.wtf/g/8/game/'
  icon128Url: 'http://clay.io/games/slime/claymedia/icon128.png'
  name: title
  description: "This is the description for game #{i}"
  rating: i % 6

prism =
  id: 4875
  key: 'prism'
  gameUrl: 'http://192.168.2.17.xip.io:3003?1'
  icon128Url: 'http://clay.io/games/slime/claymedia/icon128.png'
  name: 'Prism'
  description: 'The most amazing game ever'
  rating: 5

mock = new Zock()
  .base(config.FC_API_URL)
  .post '/experiments'
  .reply 200, {}
  .base(config.API_URL)
  .logger log.info
  .post '/users/login/anon'
  .reply 200, id: 1, accessToken: 'thisisanaccesstoken'
  .post '/users/me/lastEngagedActivity'
  .reply 200
  .post '/users'
  .reply 200, {params: {}, id: 1}
  .get '/games/top'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    [prism].concat(
      _.map _.range(skip, skip + limit), (i) ->
        game i
    )
  .get '/games/new'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), (i) ->
      game i, true
  .get '/games/findOne'
  .reply 200, (res) ->
    prism
  .get '/games/1'
  .reply 200, (res) ->
    prism
  .get '/games/4875'
  .reply 200, (res) ->
    prism
  .post '/log'
  .reply 204
  .post '/pushTokens'
  .reply 200, (res) ->
    {gameId: prism.id, token: 'mocked_token'}


window.XMLHttpRequest = ->
  mock.XMLHttpRequest()

module.exports = mock
