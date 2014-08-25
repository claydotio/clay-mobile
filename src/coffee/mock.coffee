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
  gameUrl: 'http://clay.io'
  icon128Url: 'http://slime.clay.io/claymedia/icon128.png'
  name: title
  description: "This is the description for game #{i}"
  rating: i % 6

mock = z.prop(new Zock()
  .logger log.info
  .get '/games/top'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), (i) ->
      game i
  .get '/games/new'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), (i) ->
      game i, true
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
