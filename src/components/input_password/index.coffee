z = require 'zorium'

styles = require './index.styl'

module.exports = class InputPassword
  constructor: ({value, theme}) ->
    styles.use()

    @state = z.state {
      value
      theme
    }

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val

  render: ({value, theme}) =>
    z "div.z-input-password#{if theme then theme else ''}",
      z 'input[type=password]',
        onchange: (e) =>
          @state.set value: e.target.value
        value: value
