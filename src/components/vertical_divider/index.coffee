z = require 'zorium'

styles = require './index.styl'

module.exports = class Divider
  constructor: ->
    styles.use()

  render: ->
    z 'div.z-vertical-divider'
