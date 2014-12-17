z = require 'zorium'

styles = require './index.styl'

module.exports = class InputText
  constructor: ({value, theme, disabled}) ->
    styles.use()

    @state = z.state {
      value
      disabled
      theme
    }

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val

  render: =>
    z "div.z-input-text#{if @state().theme then @state().theme else ''}",
      z "input[type=text]#{if @state().disabled then '[disabled]' else ''}",
        onchange: (e) =>
          @state.set value: e.target.value
        value: @state().value
