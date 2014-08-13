Zock = require 'zock'
z = require 'zorium'

mock = z.prop(new Zock()
  .logger (x) -> console.log x
  .get '/games/top'
  .reply 200, [{url: 'http://slime.clay.io/claymedia/icon128.png'}]
)

window.XMLHttpRequest = ->
  mock().XMLHttpRequest()

module.exports = mock
