z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

module.exports = class PrimaryButton
  constructor: ->
    @state = z.state
      $button: new Button()

  render: ({text, onclick, isFullWidth, type}) =>
    {$button} = @state()

    isFullWidth ?= false
    type ?= 'button'

    z $button,
      text: text
      onclick: onclick
      isFullWidth: isFullWidth
      type: type
      colors:
        c500: styleConfig.$orange500
        c600: styleConfig.$orange600
        c700: styleConfig.$orange700
        cText: styleConfig.$orange500Text
