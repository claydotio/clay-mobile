z = require 'zorium'

Modal = require '../../models/modal'

styles = require './index.styl'
themes =
  'google-play': require './theme_google_play.styl'

module.exports = class ModalHeader
  constructor: ({@title, @theme}) ->
    styles.use()

    if @theme
      themes[@theme]?.use()

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()
    z.redraw()

  render: =>
    z "div.modal-header#{if @theme then ".theme-#{@theme}" else ''}",
      z 'a.modal-header-close[href=#]', onclick: @close,
        z 'i.icon.icon-close'
      z 'h1.modal-header-title', "#{@title}"
