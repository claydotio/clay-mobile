z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'

User = require '../../models/user'
PhoneService = require '../../services/phone'
PrimaryButton = require '../primary_button'
Spinner = require '../spinner'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class ForgotPassword
  constructor: ->
    styles.use()

    o_phone = z.observe ''
    o_phoneError = z.observe null

    @state = z.state
      isLoading: false
      $spinner: new Spinner()
      $phoneNumberInput: new Input {
        o_value: o_phone
        o_error: o_phoneError
      }
      $signinButton: new PrimaryButton()
      o_phone: o_phone
      o_phoneError: o_phoneError

  recover: =>
    @state.set isLoading: true

    phone = @state.o_phone()

    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.recoverLogin {phone}
    .then =>
      @state.set isLoading: false
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_phoneError.set err.detail
      @state.set isLoading: false
      throw err
    .then ->
      z.router.go '/reset-password?phone=' + encodeURIComponent phone

  render: =>
    {$phoneNumberInput, $signinButton, $spinner, isLoading} = @state()

    z '.z-forgot-password',
      z 'form.form', {
        onsubmit: (e) =>
          e.preventDefault()
          @recover().catch log.trace
      },
        z $phoneNumberInput,
          hintText: 'Phone number'
          type: 'tel'
          isFloating: true
          colors:
            c500: styleConfig.$orange500
        if isLoading
          $spinner
        else
          z 'div.reset-button',
            z $signinButton,
              text: 'Reset'
              type: 'submit'
