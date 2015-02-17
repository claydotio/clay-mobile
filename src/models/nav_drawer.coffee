z = require 'zorium'

class NavDrawer
  constructor: ->
    @o_isOpen = z.observe false

  open: ->
    @o_isOpen.set true

  close: ->
    @o_isOpen.set false

module.exports = new NavDrawer()
