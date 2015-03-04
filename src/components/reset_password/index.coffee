z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'

User = require '../../models/user'
PrimaryButton = require '../primary_button'
SecondaryButton = require '../secondary_button'
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
    ga? 'send', 'event', 'reset_password', 'resend'
    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.recoverLogin {phone}
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_newPasswordError.set err.detail
      throw err
    .then =>
      # hide resend button so they can't spam-click it
      @state.set $resendButton: null

  changePassword: (phone) =>
    recoveryToken = @state.o_recoveryToken()
    newPassword = @state.o_newPassword()

    PhoneService.normalizePhoneNumber phone
    .then (phone) ->
      User.loginPhone {phone, recoveryToken, password: newPassword}
    .catch (err) =>
      # TODO: (Austin) better error handling
      @state.o_newPasswordError.set err.detail
      throw err
    .then ->
      z.router.go '/'

  render: ({phone}) =>
    {$recoveryTokenInput, $newPasswordInput, $changePasswordButton,
      $resendButton} = @state()

    z '.z-reset-password',
      z 'form.form', {
        onsubmit: (e) =>
          e.preventDefault()
          @changePassword( phone ).catch log.trace
      },
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
        z 'div.actions',
          z $resendButton,
            text: 'Resend'
            onclick: =>
              @resend phone
          z $changePasswordButton,
            text: 'Change'
            type: 'submit'
