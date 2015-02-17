z = require 'zorium'

styles = require './index.styl'

module.exports = class Card
  constructor: ({content}) ->
    styles.use()

    @state = z.state {
      content
    }

  render: ({content}) ->
    z '.z-card',
      z 'div.card-content', content
