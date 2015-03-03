z = require 'zorium'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class BackButton
  constructor: ->
    styles.use()

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
