z = require 'zorium'
_ = require 'lodash'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputSelect extends InputBase
  constructor: ({options}) ->
    styles.use()

    super

    @state.set {options, value: options[0]?.value}

  getInput$: =>
    {options} = @state()
    z 'div.z-input-select',
      z 'select', {
        onchange: (e) =>
          @state.o_value.set e.target.value
        },
        _.map options, (option) =>
          z 'option', {
            value: option.value
            selected: @state.o_value() is option.value
          },
            option.label
