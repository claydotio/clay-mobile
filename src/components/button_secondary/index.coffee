z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

module.exports = class ButtonSecondary
  constructor: ->
    @state = z.state
      $button: new Button()

  render: ({text, onclick, isFullWidth}) =>
    {$button} = @state()

    z $button,
      text: text
      onclick: onclick
      isFullWidth: isFullWidth
      colors:
        c500: styleConfig.$white
        ink: styleConfig.$black26
