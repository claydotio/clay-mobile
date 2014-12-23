z = require 'zorium'
Modal = require '../../models/modal'

styles = require './index.styl'

module.exports = class ModalClose
  constructor: ->
    styles.use()

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()
    z.redraw()

  render: =>
    z 'a.z-modal-close[href=#]', onclick: @close,
      z 'i.icon.icon-close'
