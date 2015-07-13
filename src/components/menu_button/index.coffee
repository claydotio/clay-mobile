z = require 'zorium'

Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
styleConfig = require '../../stylus/vars.json'

module.exports = class MenuButton
  constructor: ->
    @state = z.state
      $menuIcon: new Icon()

  render: ({isAlignedLeft}) =>
    {$menuIcon} = @state()

    # FIXME: fully remove
    return ''

    z 'div.z-menu-button',
      z $menuIcon,
        isAlignedLeft: isAlignedLeft
        icon: 'menu'
        color: styleConfig.$white
        onclick: (e) ->
          e?.preventDefault()
          NavDrawerModel.open()
