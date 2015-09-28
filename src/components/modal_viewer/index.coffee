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

    z 'div.z-modal-viewer-overlay',
      z 'div.z-modal-viewer-container',
        z 'div.z-modal-viewer' +
          "#{if Modal.isTransparent then '.is-transparent' else ''}",
          Modal.component
