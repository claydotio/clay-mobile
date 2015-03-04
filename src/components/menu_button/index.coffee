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

    z 'div.z-menu-button',
      z $menuIcon,
        isAlignedLeft: isAlignedLeft
        icon: 'menu'
        color: styleConfig.$white
        ontouchstart: (e) ->
          e?.preventDefault()
          NavDrawerModel.open()
        onclick: (e) ->
          e?.preventDefault()
          NavDrawerModel.open()
