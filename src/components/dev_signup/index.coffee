z = require 'zorium'
log = require 'clay-loglevel'

styles = require './index.styl'

InputBlock = require '../input_block'
InputText = require '../input_text'
InputPassword = require '../input_password'
User = require '../../models/user'
Developer = require '../../models/developer'

styles = require './index.styl'

# FIXME: remove this module? not used any where atm and login does same stuff

module.exports = class DevSignup
  constructor: ->
    styles.use()

    @state = z.state
      devName: new InputBlock {
        label: 'Dev Name'
        input: new InputText {value: '', theme: '.theme-full-width'}
      }
      email: new InputBlock {
        label: 'Email'
        input: new InputText {value: '', theme: '.theme-full-width'}
      }
      password: new InputBlock {
        label: 'Password'
        input: new InputPassword {value: '', theme: '.theme-full-width'}
      }

  signup: (e) =>
    e?.preventDefault()
    devName = @state().devName.input.getValue()
    email = @state().email.input.getValue()
    password = @state().password.input.getValue()
    User.setMe User.loginBasic {email, password}
    .then ({id}) ->
      Developer.find {ownerId: id }
    .then (developers) ->
      if developers.length is 0
        Developer.create {devName}
    .then ->
      z.router.go '/developers'
    .catch log.trace

  render: =>
    z 'div.z-dev-signup',
      z 'h1', 'Create an Account'
      z 'div.friendly-message', "It's free, and this is all we need"
      z 'form',
        {onsubmit: @signup},
        @state().devName
        @state().email
        @state().password
        z 'button.button-primary.get-started', 'Get Started'
