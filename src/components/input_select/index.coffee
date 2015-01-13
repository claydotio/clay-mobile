z = require 'zorium'
_ = require 'lodash'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputSelect extends InputBase
  constructor: ({options}) ->
    styles.use()

    super

    @state.set {options, value: options[0]?.value}

  setValue: (val) =>
    if _.find @state().options, {value: val}
      @state.set value: val
      @onchange? val

  getInput: ({options, value}) =>
    z 'div.z-input-select',
      z 'select', {
        onchange: (e) =>
          @setValue e.target.value
        },
        _.map options, (option) ->
          z 'option', {
            value: option.value
            selected: value is option.value
          },
            option.label
