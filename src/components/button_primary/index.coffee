z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

module.exports = class ButtonPrimary
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
        c500: styleConfig.$orange500
        c600: styleConfig.$orange600
        c700: styleConfig.$orange700
        cText: styleConfig.$white
