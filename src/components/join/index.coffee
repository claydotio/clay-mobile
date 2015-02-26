z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'

User = require '../../models/user'
PhoneService = require '../../services/phone'
ButtonPrimary = require '../button_primary'
Card = require '../card'
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
      $signupButton: new ButtonPrimary()
      o_nameError: o_nameError
      o_name: o_name
      o_phone: o_phone
      o_phoneError: o_phoneError
      o_password: o_password
      o_passwordError: o_passwordError

  signup: (fromUserId) =>
    name = @state.o_name()
    password = @state.o_password()
    phone = @state.o_phone()

    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.loginPhone {phone, password}
    .catch (err) =>
      # TODO: (Austin) better error handling
      error = JSON.parse err._body
      @state.o_phoneError.set error.detail
      throw err
    .then (me) ->
      User.setMe me
    .then (me) ->
      User.updateMe({name: name}).catch log.trace

      User.setSignedUpThisSession true

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
              @signup(fromUserId).catch log.trace
          },
            z $nameInput,
              hintText: 'Name'
              isFloating: true
              colors:
                c500: styleConfig.$orange500
            z $phoneInput,
              hintText: 'Phone number'
              type: 'tel'
              isFloating: true
              colors:
                c500: styleConfig.$orange500
            z $passwordInput,
              hintText: 'Password'
              type: 'password'
              isFloating: true
              colors:
                c500: styleConfig.$orange500
            z 'div.signup-button',
              z $signupButton,
                text: 'Sign up'
                onclick: =>
                  @signup(fromUserId).catch log.trace
      }
      z 'div.terms',
        'By signing up, you agree to receive SMS messages and to our '
        z 'a[href=/privacy][target=_system]', 'Privacy Policy'
        ' and '
        z 'a[href=/tos][target=_system]', 'Terms'
        '.'
