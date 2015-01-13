z = require 'zorium'

styles = require './index.styl'

module.exports = class InputTextarea
  constructor: ({value, @onchange}) ->
    styles.use()

    @state = z.state value: value

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val
    @onchange? val

  render: ({value}) =>
    z 'div.z-input-textarea',
      z 'textarea', {
      onkeyup: (e) =>
        @setValue e.target.value
      },
        value
