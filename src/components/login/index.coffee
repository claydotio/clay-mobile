z = require 'zorium'
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
      $forgotButton: new Button()
      $signinButton: new Button()

  render: =>
    {$formCard, $phoneNumberInput, $passwordInput, $signinButton,
      $forgotButton} = @state()

    z '.z-login',
      z $formCard, {
        content:
          z '.z-login_form-card-content',
            z $phoneNumberInput,
              hintText: 'Phone number'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange500
            z $passwordInput,
              hintText: 'Password'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange500
            z 'div.login-button',
              z $forgotButton,
                text: 'Forgot'
                colors: c500: styleConfig.$white, ink: styleConfig.$black26
                onclick: ->
                  z.router.go '/forgot-password'
              z $signinButton,
                text: 'Sign in'
                colors: c500: styleConfig.$orange500, ink: styleConfig.$white
      }
