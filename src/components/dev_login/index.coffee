z = require 'zorium'
log = require 'clay-loglevel'

InputBlock = require '../input_block'
InputText = require '../input_text'
InputPassword = require '../input_password'
User = require '../../models/user'
Developer = require '../../models/developer'

styles = require './index.styl'

module.exports = class DevLogin
  constructor: ->
    styles.use()

    @state = z.state
      emailBlock: new InputBlock {
        label: 'Email'
        input: new InputText {value: '', theme: '.theme-full-width'}
      }
      passwordBlock: new InputBlock {
        label: 'Password'
        input: new InputPassword {value: '', theme: '.theme-full-width'}
      }

  login: (e) =>
    e?.preventDefault()
    email = @state().emailBlock.input.getValue()
    password = @state().passwordBlock.input.getValue()
    User.setMe User.loginBasic {email, password}
    .then ({id}) ->
      Developer.find {ownerId: id }
    .then (developers) ->
      if developers.length is 0
        Developer.create()
    .then ->
      z.router.go '/developers'
    .catch (err) ->
      log.trace err
      error = JSON.parse err._body
      # TODO: (Austin) better error handling UX
      alert error.detail
    .catch log.trace

  render: ({emailBlock, passwordBlock}) ->
    z 'div.z-dev-login',
      z 'h1', 'Sign In'
      z 'div.friendly-message', 'Hey, good to see you again.'
      z 'form',
        {onsubmit: @login},
        emailBlock
        passwordBlock
        # TODO (Austin) forgot password, whenever someone aks for it
        z 'button.button-secondary.sign-in', 'Sign In'
      z 'div.tos',
        'By signup up for Clay.io, you agree to our '
        z 'a[href=/tos]', 'Terms of Service'
