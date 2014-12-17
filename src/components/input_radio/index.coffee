z = require 'zorium'

styles = require './index.styl'

module.exports = class InputRadio
  constructor: ({isChecked, label, value}) ->
    styles.use()

    @state = z.state {
      label
      value
      isChecked
      onChecked: null
    }

  isChecked: =>
    return @state().isChecked

  onChecked: (onCheckedFn) =>
    @state.set onChecked: onCheckedFn

  render: =>
    z 'div.z-input-radio',
      z 'label',
        z "input[type=radio][name=orientation]
        #{if @state().isChecked then 'checked' else ''}",
        value: @state().value
        onchange: (e) =>
          if e.target.checked
            @state().onChecked?()
        @state().label
