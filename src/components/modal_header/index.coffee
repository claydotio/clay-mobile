z = require 'zorium'

Modal = require '../../models/modal'

styles = require './index.styl'

module.exports = class ModalHeader
  constructor: ({@title, @isDark, @backgroundImage}) ->
    styles.use()

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()
    z.redraw()

  render: =>
    z "div.z-modal-header#{if @isDark then '.is-dark' else ''}",
      styles:
        backgroundImage: if @backgroundImage then "url(#{@backgroundImage})" \
                         else 'none'

      z 'a.z-modal-header-close[href=#]', onclick: @close,
        z 'i.icon.icon-close'
      z 'h1.z-modal-header-title', "#{@title}"
