z = require 'zorium'
log = require 'clay-loglevel'
Input = require 'zorium-paper/input'
Button = require 'zorium-paper/button'
Card = require 'zorium-paper/card'

User = require '../../models/user'
PhoneService = require '../../services/phone'
styleConfig = require '../../stylus/vars.json'

styles = require './index.styl'

module.exports = class ForgotPassword
  constructor: ->
    styles.use()

    o_phone = z.observe ''
    o_phoneError = z.observe null

    @state = z.state
      $formCard: new Card()
      $phoneNumberInput: new Input {
        o_value: o_phone
        o_error: o_phoneError
      }
      $signinButton: new Button()
      o_phone: o_phone
      o_phoneError: o_phoneError

  reset: ->
    PhoneService.sanitizePhoneNumber @state.o_phone()
    .then (phone) ->
      User.loginRecovery {phone}
    .catch (err) =>
      # TODO: (Austin) better error handling
      error = JSON.parse err._body
      @state.o_phoneError.set error.detail
      throw err
    .then ->
      z.router.go '/reset-password/' + encodeURIComponent phone

  render: =>
    {$formCard, $phoneNumberInput, $signinButton} = @state()

    z '.z-forgot-password',
      z $formCard, {
        content:
          z 'form.z-forgot-password_form', {
            onsubmit: (e) =>
              e.preventDefault()
              @reset().catch log.trace
          },
            # enter button on keyboard only calls onsubmit if there is
            # an input[type=submit] in the form
            # https://html.spec.whatwg.org/multipage/forms.html#implicit-submission
            z 'input[type=submit]', {style: display: 'none'}
            z $phoneNumberInput,
              hintText: 'Phone number'
              isFloating: true
              colors: c500: styleConfig.$orange500
            z 'div.reset-button',
              z $signinButton,
                text: 'Reset'
                colors: c500: styleConfig.$orange500, ink: styleConfig.$white
                onclick: =>
                  @reset().catch log.trace
      }
