z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

User = require '../../models/user'
PhoneService = require '../../services/phone'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Join
  constructor: ->
    styles.use()

    o_name = z.observe ''
    o_phone = z.observe ''
    o_password = z.observe ''

    @state = z.state
      $formCard: new Card()
      $nameInput: new Input({o_value: o_name})
      $phoneInput: new Input({o_value: o_phone})
      $passwordInput: new Input({o_value: o_password})
      $signupButton: new Button()
      o_name: o_name
      o_phone: o_phone
      o_password: o_password

  signup: (fromUserId) =>
    name = @state.o_name()
    password = @state.o_password()

    PhoneService.sanitizePhoneNumber @state.o_phone()
    .then (phone) ->
      User.loginPhone {phone, password}
    .then (me) ->
      User.setMe me

      if fromUserId
        User.addFriend fromUserId

      z.router.go '/invite'

  render: ({fromUserId}) =>
    {$formCard, $nameInput, $phoneInput, $passwordInput,
      $signupButton} = @state()

    z '.z-join',
      z $formCard, {
        content:
          z '.z-join_form-card-content',
            z $nameInput,
              hintText: 'Name'
              isFloating: true
              colors: c500: styleConfig.$orange500
            z $phoneInput,
              hintText: 'Phone number'
              type: 'tel'
              isFloating: true
              colors: c500: styleConfig.$orange500
            z $passwordInput,
              hintText: 'Password'
              type: 'password'
              isFloating: true
              colors: c500: styleConfig.$orange500
            z 'div.signup-button',
              z $signupButton,
                text: 'Sign up'
                colors: c500: styleConfig.$orange500, ink: styleConfig.$white
                onclick: =>
                  @signup(fromUserId).catch log.trace
      }
      z 'div.terms',
        'By signing up, you agree to receive SMS messages and to our '
        z 'a[href=/privacy][target=_system]', 'Privacy Policy'
        ' and '
        z 'a[href=/tos][target=_system]', 'Terms'
        '.'
