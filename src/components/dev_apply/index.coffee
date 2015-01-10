z = require 'zorium'
log = require 'clay-loglevel'

styles = require './index.styl'

InputBlock = require '../input_block'
InputText = require '../input_text'
InputPassword = require '../input_password'
User = require '../../models/user'
Developer = require '../../models/developer'

styles = require './index.styl'

module.exports = class DevApply
  constructor: ->
    styles.use()

    @state = z.state
      emailBlock: new InputBlock {
        label: 'Email'
        input: new InputText {value: '', theme: '.theme-full-width'}
      }
      gameUrlBlock: new InputBlock {
        label: 'Game URL'
        input: new InputText {value: '', theme: '.theme-full-width'}
      }

  apply: (e) ->
    e?.preventDefault()

    # FIXME

  render: ({emailBlock, gameUrlBlock}) ->
    z 'div.z-dev-apply',
      z 'h1', 'Request an invite'
      z 'div.friendly-message',
        z 'p',
          'We aim to provide the best possible support to every developer on
          Clay.'
        z 'p',
          "To do this we're limiting signups for now. Share your awesome game
          with us and we'll send you an invite when we can."

      z 'form',
        {onsubmit: @apply},
        emailBlock
        gameUrlBlock
        z 'button.button-primary.apply', 'Apply!'
