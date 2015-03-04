z = require 'zorium'

class NavDrawer
  constructor: ->
    @o_isOpen = z.observe false

  isOpen: =>
    @o_isOpen

  open: =>
    @o_isOpen.set true
    # prevent body scrolling while viewing menu
    document.body.style.overflow = 'hidden'

  close: =>
    @o_isOpen.set false
    document.body.style.overflow = 'auto'

module.exports = new NavDrawer()
