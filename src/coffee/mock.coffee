_ = require 'lodash'
Zock = require 'zock'
z = require 'zorium'
log = require 'loglevel'

mock = z.prop(new Zock()
  .logger log.info
  .get '/games/top'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), (i) ->
      {url: 'http://slime.clay.io/claymedia/icon128.png', title: "title #{i}"}
  .get '/games/new'
  .reply 200, (res) ->
    limit = parseInt(res.query.limit, 10) or 10
    skip = parseInt(res.query.skip, 10) or 0
    _.map _.range(skip, skip + limit), (i) ->
      {url: 'http://clay.io/images/logo-cloud.png', title: "title #{i}"}
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
