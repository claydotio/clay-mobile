z = require 'zorium'

styles = require './index.styl'

module.exports = class Spinner
  constructor: ->
    styles.use()

  render: ->
    z '.spinner-container',
      z '.spinner'
