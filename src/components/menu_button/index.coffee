z = require 'zorium'

Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
styleConfig = require '../../stylus/vars.json'

module.exports = class MenuButton
  constructor: ->
    @state = z.state
      $menuIcon: new Icon()

  render: =>
    {$menuIcon} = @state()

    z 'div.z-menu-button',
      z $menuIcon,
        icon: 'menu'
        size: '24px'
        color: styleConfig.$white
        onclick: ->
          NavDrawerModel.open()
