z = require 'zorium'
Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class ForgotPassword
  constructor: ->
    styles.use()

    @state = z.state
      $formCard: new Card()
      $phoneNumberInput: new Input()
      $signinButton: new Button()

  render: =>
    {
      $formCard
      $phoneNumberInput
      $signinButton
    } = @state()

    z '.z-forgot-password',
      z $formCard, {
        content:
          z '.z-forgot-password_form-card-content',
            z $phoneNumberInput,
              hintText: 'Phone number'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange
            z 'div.reset-button',
              z $signinButton,
                text: 'Reset'
                colors: c500: styleConfig.$orange, ink: styleConfig.$white
      }
