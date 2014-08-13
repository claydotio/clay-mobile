Zock = require 'zock'
z = require 'zorium'
log = require 'loglevel'

mock = z.prop(new Zock()
  .logger log.info
  .get '/games/top'
  .reply 200, [{url: 'http://slime.clay.io/claymedia/icon128.png'}]
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
