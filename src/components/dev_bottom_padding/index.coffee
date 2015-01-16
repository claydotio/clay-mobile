z = require 'zorium'

styles = require './index.styl'

module.exports = class DevBottomPadding
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-bottom-padding'
