class Modal
  constructor: ->
    @component = null
    @theme = null

  openComponent: ({@component, @theme}) -> null

  closeComponent: ->
    @component = null

module.exports = new Modal()
