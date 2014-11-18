z = require 'zorium'

config = require '../../config'
Modal = require '../../models/modal'

styles = require './index.styl'

module.exports = class ModalViewer
  constructor: ->
    styles.use()

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()

  render: ->
    return unless Modal.component

    z 'div.modal-viewer-overlay',
      z 'div.modal-viewer-container',
        z 'div.modal-viewer',
          Modal.component
