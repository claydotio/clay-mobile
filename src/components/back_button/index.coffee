z = require 'zorium'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

module.exports = class BackButton
  constructor: ->
    @state = z.state
      $backIcon: new Icon()

  render: ({isAlignedLeft}) =>
    {$backIcon} = @state()

    z 'div.z-back-button',
      z $backIcon,
        isAlignedLeft: isAlignedLeft
        icon: 'arrow-back'
        color: styleConfig.$white
        onclick: ->
          window.history.back()
