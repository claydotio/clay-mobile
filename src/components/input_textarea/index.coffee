z = require 'zorium'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputTextarea extends InputBase
  constructor: ({value}) ->
    styles.use()

    super

  getInput: ({value}) =>
    z 'div.z-input-textarea',
      z 'textarea', {
      onkeyup: (e) =>
        @setValue e.target.value
      },
        value
