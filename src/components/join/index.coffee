z = require 'zorium'
log = require 'clay-loglevel'

Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Join
  constructor: ->
    styles.use()

    @state = z.state
      $formCard: new Card()
      $nameInput: new Input()
      $phoneNumberInput: new Input()
      $passwordInput: new Input()
      $signupButton: new Button()

  render: =>
    {
      $formCard
      $nameInput
      $phoneNumberInput
      $passwordInput
      $signupButton
      showProfilePicture
    } = @state()

    z '.z-join',
      z $formCard, {
        content:
          z '.z-join_form-card-content',
            z $nameInput,
              hintText: 'Name'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange
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
              z $signupButton,
                text: 'Sign up'
                colors: c500: styleConfig.$orange, ink: styleConfig.$white
      }
      z 'div.terms',
        'By signing up, you agree to receive SMS messages and to our '
        z 'a[href=/privacy][target=_system]', 'Privacy Policy'
        ' and '
        z 'a[href=/tos][target=_system]', 'Terms'
        '.'
