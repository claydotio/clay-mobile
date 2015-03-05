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

module.exports = class ResetPassword
  constructor: ->
    styles.use()

    o_recoveryToken = z.observe ''
    o_recoveryTokenError = z.observe null
    o_newPassword = z.observe ''
    o_newPasswordError = z.observe null

    @state = z.state
      isLoading: false
      $spinner: new Spinner()
      $recoveryTokenInput: new Input {
        o_value: o_recoveryToken
        o_error: o_recoveryTokenError
      }
      $newPasswordInput: new Input {
        o_value: o_newPassword
        o_error: o_newPasswordError
      }
      $changePasswordButton: new PrimaryButton()
      $resendButton: new SecondaryButton()
      o_recoveryToken: o_recoveryToken
      o_recoveryTokenError: o_recoveryTokenError
      o_newPassword: o_newPassword
      o_newPasswordError: o_newPasswordError

  resend: (phone) =>
    @state.set isLoading: true

    ga? 'send', 'event', 'reset_password', 'resend'
    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.recoverLogin {phone}
    .then =>
      @state.set isLoading: false
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_newPasswordError.set err.detail
      @state.set isLoading: false
      throw err
    .then =>
      # hide resend button so they can't spam-click it
      @state.set $resendButton: null

  changePassword: (phone) =>
    @state.set isLoading: true

    recoveryToken = @state.o_recoveryToken()
    newPassword = @state.o_newPassword()

    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.loginPhone {phone, recoveryToken, password: newPassword}
    .then (me) =>
      @state.set isLoading: false
      return me
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_newPasswordError.set err.detail
      @state.set isLoading: false
      throw err
    .then (me) ->
      User.setMe Promise.resolve me
      z.router.go '/'

  render: ({phone}) =>
    {$recoveryTokenInput, $newPasswordInput, $changePasswordButton,
      $resendButton, $spinner, isLoading} = @state()

    z '.z-reset-password',
      z 'form.form', {
        onsubmit: (e) =>
          e.preventDefault()
          @changePassword(phone).catch log.trace
      },
        # enter button on keyboard only calls onsubmit if there is
        # an input[type=submit] in the form
        # https://html.spec.whatwg.org/multipage/forms.html#implicit-submission
        z 'input[type=submit]', {style: display: 'none'}
        z $recoveryTokenInput,
          hintText: 'Reset Code'
          isFloating: true
          colors:
            c500: styleConfig.$orange500
        z $newPasswordInput,
          hintText: 'New Password'
          type: 'password'
          isFloating: true
          colors:
            c500: styleConfig.$orange500
        if isLoading
          $spinner
        else
          z 'div.actions',
            z $resendButton,
              text: 'Resend'
              onclick: =>
                @resend(phone).catch log.trace

            z $changePasswordButton,
              text: 'Change'
              onclick: (e) =>
                e.preventDefault()
                @changePassword(phone).catch log.trace
