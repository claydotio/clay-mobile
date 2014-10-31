z = require 'zorium'

config = require '../config'
Modal = require '../models/modal'

module.exports = class ModalViewer
  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()

  render: ->
    return unless Modal.component

    theme = if Modal.theme then ".theme-#{Modal.theme}" else ''

    z "div.modal-viewer-overlay#{theme}",
      z 'div.modal-viewer-container',
        z 'div.modal-viewer',
          Modal.component.render()
