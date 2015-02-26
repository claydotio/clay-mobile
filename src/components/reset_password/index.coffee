z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

User = require '../../models/user'
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
      $formCard: new Card()
      $recoveryTokenInput: new Input {
        o_value: o_recoveryToken
        o_error: o_recoveryTokenError
      }
      $newPasswordInput: new Input {
        o_value: o_newPassword
        o_error: o_newPasswordError
      }
      $changePasswordButton: new Button()
      $resendButton: new Button()
      o_recoveryToken: o_recoveryToken
      o_recoveryTokenError: o_recoveryTokenError
      o_newPassword: o_newPassword
      o_newPasswordError: o_newPasswordError

  resend: (phone) =>
    ga? 'send', 'event', 'reset_password', 'resend'
    PhoneService.sanitizePhoneNumber phone
    .then (phone) ->
      User.loginRecovery {phone}
    .catch (err) =>
      error = JSON.parse err._body
      @state.o_newPasswordError.set error.detail
      throw err
    .then =>
      @state.set $resendButton: null

  changePassword: (phone) =>
    recoveryToken = @state.o_recoveryToken()
    newPassword = @state.o_newPassword()

    PhoneService.sanitizePhoneNumber phone
    .then (phone) ->
      User.loginPhone {phone, recoveryToken, password: newPassword}
    .catch (err) =>
      error = JSON.parse err._body
      @state.o_newPasswordError.set error.detail
      throw err
    .then ->
      z.router.go '/'

  render: ({phone}) =>
    {$formCard, $recoveryTokenInput, $newPasswordInput, $changePasswordButton,
      $resendButton} = @state()

    z '.z-reset-password',
      z $formCard, {
        content:
          z 'form.z-reset-password_form', {
            onsubmit: (e) =>
              e.preventDefault()
              @changePassword( phone ).catch log.trace
          },
            # enter button on keyboard only calls onsubmit if there is
            # an input[type=submit] in the form
            # https://html.spec.whatwg.org/multipage/forms.html#implicit-submission
            z 'input[type=submit]', {style: display: 'none'}
            z $recoveryTokenInput,
              hintText: 'Reset Code'
              isFloating: true
              colors: c500: styleConfig.$orange500
            z $newPasswordInput,
              hintText: 'New Password'
              type: 'password'
              isFloating: true
              colors: c500: styleConfig.$orange500
            z 'div.actions',
              z $resendButton,
                text: 'Resend'
                colors: c500: styleConfig.$white, ink: styleConfig.$black26
                onclick: =>
                  @resend phone
              z $changePasswordButton,
                text: 'Change'
                colors: c500: styleConfig.$orange500, ink: styleConfig.$white
                onclick: =>
                  @changePassword(phone).catch log.trace
      }
