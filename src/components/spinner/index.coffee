z = require 'zorium'

styles = require './index.styl'

module.exports = class Spinner
  constructor: ->
    styles.use()

  render: ->
    z '.z-spinner-container',
      z '.z-spinner'
