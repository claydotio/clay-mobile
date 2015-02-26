z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'

User = require '../../models/user'
Card = require '../card'
ButtonPrimary = require '../button_primary'
ButtonSecondary = require '../button_secondary'
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
      $formCard: new Card()
      $phoneInput: new Input {
        o_value: o_phone
        o_error: o_phoneError
      }
      $passwordInput: new Input {
        o_value: o_password
        o_error: o_passwordError
      }
      $forgotButton: new ButtonSecondary()
      $signinButton: new ButtonPrimary()
      o_phone: o_phone
      o_phoneError: o_phoneError
      o_password: o_password
      o_passwordError: o_passwordError

  login: =>
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
      z.router.go '/'

  render: =>
    {$formCard, $phoneInput, $passwordInput, $signinButton,
      $forgotButton} = @state()

    z '.z-login',
      z $formCard, {
        content:
          z 'form.z-login_form', {
            onsubmit: (e) =>
              e.preventDefault()
              @login().catch log.trace
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
            z 'div.actions',
              z $forgotButton,
                text: 'Forgot'
                onclick: ->
                  z.router.go '/forgot-password'
              z $signinButton,
                text: 'Sign in'
                onclick: =>
                  @login().catch log.trace
      }
