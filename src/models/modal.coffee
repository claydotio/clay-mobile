z = require 'zorium'

class Modal
  constructor: ->
    @component = null

  openComponent: ({@component, @isTransparent}) =>
    z.redraw()

  closeComponent: =>
    @component = null
    @isTransparent = null
    z.redraw()

module.exports = new Modal()
