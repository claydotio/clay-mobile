z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class InputSelect
  constructor: ({options}) ->
    styles.use()

    # FIXME: defualt value
    @state = z.state {options, value: ''}

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val

  render: ({options, value}) =>
    z 'div.z-input-select',
      z 'select', {
        onchange: (e) =>
          @state.set value: e.target.value
        },
        _.map options, (option) ->
          z 'option', {value: option.value},
            option.label
