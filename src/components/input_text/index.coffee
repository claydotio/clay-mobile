z = require 'zorium'

styles = require './index.styl'

module.exports = class InputText
  constructor: ({value, type, theme, disabled, placeholder}) ->
    styles.use()

    type ?= 'text'

    @state = z.state {
      value
      type
      disabled
      placeholder
      theme
    }

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val

  render: ({value, type, disabled, placeholder, theme}) ->
    z "div.z-input-text#{if theme then theme else ''}",
      z "input[type=#{type}]
        #{if disabled then '[disabled]' else ''}
        #{if placeholder then "[placeholder=#{placeholder}]" else ''}",
        onkeyup: (e) =>
          @state.set value: e.target.value
        value: value
