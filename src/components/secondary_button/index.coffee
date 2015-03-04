z = require 'zorium'
Button = require 'zorium-paper/button'

styleConfig = require '../../stylus/vars.json'

module.exports = class SecondaryButton
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
      colors:
        ink: styleConfig.$black26
