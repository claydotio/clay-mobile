_ = require 'lodash'
Zock = require 'zock'
z = require 'zorium'
log = require 'loglevel'

mock = z.prop(new Zock()
  .logger log.info
  .get '/games/top'
  .reply 200, _.map [0...10], ->
    {url: 'http://slime.clay.io/claymedia/icon128.png'}
  .get '/games/new'
  .reply 200, _.map [0...10], ->
    {url: 'http://clay.io/images/logo-cloud.png'}
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
