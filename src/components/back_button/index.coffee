z = require 'zorium'

Icon = require '../icon'
NavDrawerModel = require '../../models/nav_drawer'
styleConfig = require '../../stylus/vars.json'

module.exports = class BackButton
  constructor: ->
    @state = z.state
      $backIcon: new Icon()

  render: =>
    {$backIcon} = @state()

    z 'div.z-back-button',
      z $backIcon,
        icon: 'arrowBack'
        size: '24px'
        color: styleConfig.$white
        onclick: ->
          window.history.back()
