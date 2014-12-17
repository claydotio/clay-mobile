z = require 'zorium'

styles = require './index.styl'

InputBlock = require '../input_block'
InputText = require '../input_text'
InputPassword = require '../input_password'

styles = require './index.styl'

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

  render: =>
    z 'div.z-dev-signup',
      z 'h1', 'Create an Account'
      z 'div.friendly-message', "It's free, and this is all we need"
      z 'form',
        @state().devName
        @state().email
        @state().password
        z 'button.button-primary.get-started', 'Get Started'
