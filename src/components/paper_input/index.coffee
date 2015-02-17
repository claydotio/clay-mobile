z = require 'zorium'

paperColors = require '../../stylus/paper_colors.json'
styles = require './index.styl'

module.exports = class Input
  constructor: ({colors, hintText, isFloating,
                isDisabled, @o_value, @o_error, isDark}) ->
    styles.use()

    colors ?= {
      c500: paperColors.$black
    }
    hintText ?= ''
    isFloating ?= false
    isDisabled ?= false
    @o_value ?= z.observe ''
    @o_error ?= z.observe null

    @o_isFocused = z.observe false

    @state = z.state {
      colors
      hintText
      isFocused: @o_isFocused
      value: @o_value
      error: @o_error
      isFloating
      isDisabled
      isDark
    }

  render: ({colors, hintText, isFloating,
            isDisabled, value, isFocused, error, isDark}) =>
    z '.z-input',
      className: z.classKebab {
        isDark
        isFloating
        hasValue: value isnt ''
        isFocused
        isDisabled
        isError: error?
      }
      z '.hint', {
        style:
          color: if isFocused and not error? \
                 then colors.c500 else null
      },
        hintText
      z 'input.input',
        attributes:
          disabled: if isDisabled then true else undefined
        value: value
        oninput: z.ev (e, $$el) =>
          @o_value.set $$el.value
        onfocus: z.ev (e, $$el) =>
          @o_isFocused.set true
        onblur: z.ev (e, $$el) =>
          @o_isFocused.set false
      z '.underline',
        style:
          backgroundColor: if isFocused and not error? \
                           then colors.c500 else null
      if error?
        z '.error', error
