z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Login
  constructor: ->
    styles.use()

    @state = z.state
      $formCard: new Card()
      $phoneNumberInput: new Input()
      $passwordInput: new Input()
      $signinButton: new Button()

  render: =>
    {
      $formCard
      $phoneNumberInput
      $passwordInput
      $signinButton
      showProfilePicture
    } = @state()

    z '.z-login',
      z $formCard, {
        content:
          z '.z-login_form-card-content',
            z $phoneNumberInput,
              hintText: 'Phone number'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange
            z $passwordInput,
              hintText: 'Password'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange
            z 'div.signup-button',
              z $signinButton,
                text: 'Sign in'
                colors: c500: styleConfig.$orange, ink: styleConfig.$white
      }
