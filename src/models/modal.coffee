z = require 'zorium'

class Modal
  constructor: ->
    @component = null

  openComponent: ({@component}) ->
    z.redraw()

  closeComponent: ->
    @component = null
    z.redraw()

module.exports = new Modal()
