z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'

User = require '../../models/user'
PhoneService = require '../../services/phone'
PrimaryButton = require '../primary_button'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class ForgotPassword
  constructor: ->
    styles.use()

    o_phone = z.observe ''
    o_phoneError = z.observe null

    @state = z.state
      $phoneNumberInput: new Input {
        o_value: o_phone
        o_error: o_phoneError
      }
      $signinButton: new PrimaryButton()
      o_phone: o_phone
      o_phoneError: o_phoneError

  recover: =>
    phone = @state.o_phone()

    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.recoverLogin {phone}
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_phoneError.set err.detail
      throw err
    .then ->
      z.router.go '/reset-password/' + encodeURIComponent phone

  render: =>
    {$phoneNumberInput, $signinButton} = @state()

    z '.z-forgot-password',
      z 'form.form', {
        onsubmit: (e) =>
          e.preventDefault()
          @recover().catch log.trace
      },
        z $phoneNumberInput,
          hintText: 'Phone number'
          isFloating: true
          colors:
            c500: styleConfig.$orange500
        z 'div.reset-button',
          z $signinButton,
            text: 'Reset'
            type: 'submit'
