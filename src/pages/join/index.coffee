z = require 'zorium'

Join = require '../../components/join'

module.exports = class JoinPage
  constructor: ->
    @state = z.state
      join: new Join()

  render: ({join}) ->
    z 'div',
      z 'div', join
