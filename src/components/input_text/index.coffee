z = require 'zorium'

styles = require './index.styl'

module.exports = class InputText
  constructor: ({value, theme, disabled, placeholder}) ->
    styles.use()

    @state = z.state {
      value
      disabled
      placeholder
      theme
    }

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val

  render: ({value, disabled, placeholder, theme}) ->
    z "div.z-input-text#{if theme then theme else ''}",
      z "input[type=text]
        #{if disabled then '[disabled]' else ''}
        #{if placeholder then "[placeholder=#{placeholder}]" else ''}",
        onchange: (e) =>
          @state.set value: e.target.value
        value: value
