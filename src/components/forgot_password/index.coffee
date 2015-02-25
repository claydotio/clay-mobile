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

    @state = z.state
      $formCard: new Card()
      $phoneNumberInput: new Input({o_value: o_phone})
      $signinButton: new Button()
      o_phone: o_phone

  reset: ->
    PhoneService.sanitizePhoneNumber @state.o_phone()
    .then (phone) ->
      User.loginRecovery {phone}
      z.router.go '/reset-password/' + encodeURIComponent phone

  render: =>
    {$formCard, $phoneNumberInput, $signinButton} = @state()

    z '.z-forgot-password',
      z $formCard, {
        content:
          z '.z-forgot-password_form-card-content',
            z $phoneNumberInput,
              hintText: 'Phone number'
              isFloating: true
              o_value: z.observe ''
              colors: c500: styleConfig.$orange500
            z 'div.reset-button',
              z $signinButton,
                text: 'Reset'
                colors: c500: styleConfig.$orange500, ink: styleConfig.$white
                onclick: =>
                  @reset().catch log.trace
      }
