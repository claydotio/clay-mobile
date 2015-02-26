z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

User = require '../../models/user'
PhoneService = require '../../services/phone'
localstore = require '../../lib/localstore'
config = require '../../config'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Join
  constructor: ->
    styles.use()

    o_name = z.observe ''
    o_nameError = z.observe null
    o_phone = z.observe ''
    o_phoneError = z.observe null
    o_password = z.observe ''
    o_passwordError = z.observe null

    @state = z.state
      $formCard: new Card()
      $nameInput: new Input {
        o_value: o_name
        o_error: o_nameError
      }
      $phoneInput: new Input {
        o_value: o_phone
        o_error: o_phoneError
      }
      $passwordInput: new Input {
        o_value: o_password
        o_error: o_passwordError
      }
      $signupButton: new Button()
      o_nameError: o_nameError
      o_name: o_name
      o_phone: o_phone
      o_phoneError: o_phoneError
      o_password: o_password
      o_passwordError: o_passwordError

  signup: (fromUserId) =>
    name = @state.o_name()
    password = @state.o_password()

    PhoneService.sanitizePhoneNumber @state.o_phone()
    .then (phone) ->
      User.loginPhone {phone, password}
    .catch (err) =>
      # TODO: (Austin) better error handling
      error = JSON.parse err._body
      @state.o_phoneError.set error.detail
      throw err
    .then (me) ->
      User.setMe Promise.resolve me
    .then (me) ->
      User.updateMe({name: name}).catch log.trace

      localstore.set config.LOCALSTORE_SHOW_THANKS, {set: true}

      if fromUserId
        User.addFriend(fromUserId).catch log.trace

      ga? 'send', 'event', 'user', 'signup', fromUserId
      User.convertExperiment 'phone_signup'

      z.router.go '/invite'

  render: ({fromUserId}) =>
    {$formCard, $nameInput, $phoneInput, $passwordInput,
      $signupButton} = @state()

    z '.z-join',
      z $formCard, {
        content:
          z 'form.z-join_form', {
            onsubmit: (e) =>
              e.preventDefault()
              @signup().catch log.trace
          },
            # enter button on keyboard only calls onsubmit if there is
            # an input[type=submit] in the form
            # https://html.spec.whatwg.org/multipage/forms.html#implicit-submission
            z 'input[type=submit]', {style: display: 'none'}
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
