z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'

User = require '../../models/user'
PrimaryButton = require '../primary_button'
SecondaryButton = require '../secondary_button'
Spinner = require '../spinner'
PhoneService = require '../../services/phone'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class Login
  constructor: ->
    styles.use()

    o_phone = z.observe ''
    o_phoneError = z.observe null
    o_password = z.observe ''
    o_passwordError = z.observe null

    @state = z.state
      isLoading: false
      $spinner: new Spinner()
      $phoneInput: new Input {
        o_value: o_phone
        o_error: o_phoneError
      }
      $passwordInput: new Input {
        o_value: o_password
        o_error: o_passwordError
      }
      $forgotButton: new SecondaryButton()
      $signinButton: new PrimaryButton()
      o_phone: o_phone
      o_phoneError: o_phoneError
      o_password: o_password
      o_passwordError: o_passwordError

  login: (fromUserId) =>
    @state.set isLoading: true

    password = @state.o_password()
    phone = @state.o_phone()

    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.loginPhone {phone, password}
    .then (me) =>
      @state.set isLoading: false
      return me
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_phoneError.set err.detail
      @state.set isLoading: false
      throw err
    .then (me) ->
      User.setMe Promise.resolve me

      if fromUserId
        User.addFriend(fromUserId).catch log.trace

      z.router.go '/'

  render: ({fromUserId}) =>
    {$phoneInput, $passwordInput, $signinButton,
      $forgotButton, $spinner, isLoading} = @state()

    z '.z-login',
      z 'form.form', {
        onsubmit: (e) =>
          e.preventDefault()
          @login(fromUserId).catch log.trace
      },
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
        if isLoading
          $spinner
        else
          z 'div.actions',
            z $forgotButton,
              text: 'Forgot'
              onclick: ->
                z.router.go '/forgot-password'
            z $signinButton,
              text: 'Sign in'
              type: 'submit'
