z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class InputSelect
  constructor: ({options, @onchange}) ->
    styles.use()

    @state = z.state {options, value: options[0]?.value}

    _.map options, (option) =>
      if option.isSelected
        @state.set value: option.value

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val
    @onchange? val

  render: ({options, value}) =>
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
