class Modal
  constructor: ->
    @component = null

  openComponent: ({@component}) -> null

  closeComponent: ->
    @component = null

module.exports = new Modal()
