z = require 'zorium'

styles = require './index.styl'

module.exports = class GuestFooter
  constructor: ->
    styles.use()

  render: ->
    z '.z-dev-footer'
