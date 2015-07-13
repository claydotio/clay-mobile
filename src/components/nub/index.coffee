z = require 'zorium'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Nub
  constructor: ({@toggleCallback}) ->
    styles.use()

    @state = z.state
      $menuIcon: new Icon()

  render: =>
    {$menuIcon} = @state()

    z 'div.z-nub', onclick: @toggleCallback, # FIXME
      z $menuIcon,
        icon: 'menu'
        color: styleConfig.$orange500
        isAlignedRight: true
        isAlignedTop: true
