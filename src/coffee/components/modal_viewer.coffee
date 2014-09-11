z = require 'zorium'

config = require '../config'
Modal = require '../models/modal'

module.exports = class ModalViewer
  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()

  render: =>
    return unless Modal.component

    z 'div.modal-overlay',
      z 'div.modal-container',
        z 'div.modal',
          z 'a.modal-close[href=#]', onclick: @close,
            z 'i.icon.icon-close'
          Modal.component.render()
