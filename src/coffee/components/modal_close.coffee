z = require 'zorium'
Modal = require '../models/modal'

module.exports = class ModalClose
  constructor: -> null

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()

  render: =>
    z 'a.modal-close[href=#]', onclick: @close,
      z 'i.icon.icon-close'
