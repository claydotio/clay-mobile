z = require 'zorium'

Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class MenuButton
  constructor: ->
    styles.use()

    @state = z.state
      $menuIcon: new Icon()

  render: ({isShiftedLeft}) =>
    {$menuIcon} = @state()

    z 'div.z-menu-button', {
      className: z.classKebab {isShiftedLeft}
    },
      z $menuIcon,
        icon: 'menu'
        color: styleConfig.$white
        onclick: ->
          NavDrawerModel.open()
