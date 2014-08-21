_ = require 'lodash'
Zock = require 'zock'
z = require 'zorium'
log = require 'loglevel'

game = (i) ->
  key: i
  gameUrl: 'http://clay.io'
  icon128Url: 'http://slime.clay.io/claymedia/icon128.png'
  name: "game #{i}"
  description: "This is the description for game #{i}"
  rating: i % 6

mock = z.prop(new Zock()
  .logger log.info
  .get '/games/top'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), game
  .get '/games/new'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), game
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
