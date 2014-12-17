z = require 'zorium'

styles = require './index.styl'

module.exports = class InputTextarea
  constructor: ({value}) ->
    styles.use()

    @state = z.state value: value

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val

  render: =>
    z 'div.z-input-textarea',
      z 'textarea', {
      onchange: (e) =>
        @state.set value: e.target.value
      },
        @state().value
