z = require 'zorium'

Modal = require '../../models/modal'

styles = require './index.styl'

module.exports = class ModalHeader
  constructor: ({title, isDark, backgroundImage}) ->
    styles.use()

    @state = z.state {title, isDark, backgroundImage}

  close: (e) ->
    e?.preventDefault()
    Modal.closeComponent()
    z.redraw()

  render: =>
    {title, isDark, backgroundImage} = @state()

    z "div.z-modal-header#{if isDark then '.is-dark' else ''}",
      style:
        backgroundImage: if backgroundImage then "url(#{backgroundImage})" \
                         else 'none'

      z 'a.close[href=#]', onclick: @close,
        z 'i.icon.icon-close'
      z 'h1.title', "#{title}"
