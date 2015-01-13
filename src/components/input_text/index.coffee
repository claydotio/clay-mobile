z = require 'zorium'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputText extends InputBase
  constructor: ({type, disabled, postfix}) ->
    styles.use()

    super

    type ?= 'text'

    @state.set {
      type
      disabled
      postfix
    }

  getInput: ({value, type, disabled, theme, postfix}) =>
    z "div.z-input-text#{if theme then theme else ''}",
      z "input[type=#{type}]#{if disabled then '[disabled]' else ''}",
        onkeyup: (e) =>
          @setValue e.target.value
        value: value
      if postfix
        z 'input[type=text][disabled].postfix', value: postfix
