z = require 'zorium'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputText extends InputBase
  constructor: ({type, postfix}) ->
    styles.use()

    super

    type ?= 'text'

    @state.set {
      type
      postfix
    }

  setValue: (e) =>
    @state.o_value.set e.target.value

  getInput$: =>
    {type, disabled, theme, postfix} = @state()
    z "div.z-input-text#{if theme then theme else ''}",
      z "input[type=#{type}]#{if disabled then '[disabled]' else ''}",
        onkeyup: @setValue
        onchange: @setValue
        value: @state.o_value()
      if postfix
        z 'input[type=text][disabled].postfix', value: postfix
