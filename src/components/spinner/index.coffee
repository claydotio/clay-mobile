z = require 'zorium'

require './index.styl'

module.exports = class Spinner
  render: ->
    z '.spinner-container',
      z '.spinner'
