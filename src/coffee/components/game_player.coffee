z = require 'zorium'
_ = require 'lodash'

module.exports = class GamePlayer
  constructor: ({gameKey}) ->
    @gameKey = z.prop gameKey

  render: =>
    z 'div', @gameKey()
