_ = require 'lodash'
Zock = require 'zock'
z = require 'zorium'
log = require 'loglevel'

game = (i, isNew) ->
  title = "game #{i}"

  # Prefix new games titles
  if isNew
    title = 'new ' + title

  # Every 5th game has a long title
  if i % 5 == 0
    title += ' with a really long title that is here'

  key: i
  gameUrl: 'http://cdn.wtf/g/8/game/'
  icon128Url: 'http://clay.io/games/slime/claymedia/icon128.png'
  name: title
  description: "This is the description for game #{i}"
  rating: i % 6

prism =
  key: 'prism'
  gameUrl: 'http://192.168.2.98.xip.io:3003'
  icon128Url: 'http://clay.io/games/slime/claymedia/icon128.png'
  name: 'Prism'
  description: 'The most amazing game ever'
  rating: 5

mock = z.prop(new Zock()
  .logger log.info
  .post '/users/login/anon'
  .reply 200, id: 1
  .post '/users'
  .reply 200, {params: {}}
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
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
