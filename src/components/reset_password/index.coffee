z = require 'zorium'
Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class ResetPassword
  constructor: ->
    styles.use()

    @state = z.state
      $formCard: new Card()
      $resetCodeInput: new Input()
      $newPasswordInput: new Input()
      $changePasswordButton: new Button()
      $resendButton: new Button()

  render: =>
    {
      $formCard
      $resetCodeInput
      $newPasswordInput
      $changePasswordButton
      $resendButton
    } = @state()

    z '.z-reset-password',
      z $formCard, {
        content:
          z '.z-reset-password_form-card-content',
            z $resetCodeInput,
              hintText: 'Reset Code'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange
            z $newPasswordInput,
              hintText: 'New Password'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange
            z 'div.actions',
              z $resendButton,
                text: 'Resend'
                colors: c500: styleConfig.$white, ink: styleConfig.$greyDark
              z $changePasswordButton,
                text: 'Change'
                colors: c500: styleConfig.$orange, ink: styleConfig.$white
      }
