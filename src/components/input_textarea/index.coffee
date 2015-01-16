z = require 'zorium'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputTextarea extends InputBase
  constructor: ->
    styles.use()

    super

  setValue: (e) =>
    @state.o_value.set e.target.value

  getInput$: =>
    z 'div.z-input-textarea',
      z 'textarea', {
        onkeyup: @setValue
        onchange: @setValue
      },
        @state().o_value
