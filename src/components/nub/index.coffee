z = require 'zorium'

require './index.styl'

module.exports = class Nub
  constructor: ({@onToggle, @theme}) ->
    @isOpen = false

  toggleOpenState: (e) =>
    e?.preventDefault()

    # TODO (Austin): open state for nub is only required for control
    # (chevron direction). If we get rid of control, move state to drawer.
    # If we keep control, use an event stream
    @isOpen = not @isOpen
    @onToggle?()

    # This is a workaround for this Mithril issue:
    # https://github.com/lhorie/mithril.js/issues/273
    # Without this, if the game iframe is clicked before the drawer nub
    # then the iframe is re-loaded because it is the activeElement
    # during the Mithril DOM-diff
    window.document.activeElement?.blur()
    z.redraw()

  render: =>
    if @theme is 'transparent-menu'
      z 'div.nub.theme-transparent-menu', ontouchstart: @toggleOpenState,
        z 'i.icon.icon-menu'

    else
      # drawer state
      if @isOpen
        chevronDirection = 'right'
      else
        chevronDirection = 'left'

      z 'div.nub.theme-control', ontouchstart: @toggleOpenState,
        z "i.icon.icon-chevron-#{chevronDirection}"
