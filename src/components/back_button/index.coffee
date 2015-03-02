z = require 'zorium'

Icon = require '../icon'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class BackButton
  constructor: ->
    styles.use()

    @state = z.state
      $backIcon: new Icon()

  render: ({isShiftedLeft}) =>
    {$backIcon} = @state()

    z 'div.z-back-button', {
      className: z.classKebab {isShiftedLeft}
    },
      z $backIcon,
        icon: 'arrow-back'
        color: styleConfig.$white
        onclick: ->
          window.history.back()
