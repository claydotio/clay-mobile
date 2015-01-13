z = require 'zorium'

styles = require './index.styl'

module.exports = class InputRadio
  constructor: ({label, name, value, isChecked}) ->
    styles.use()

    @state = z.state {
      label
      inputName: name # name key clashes with Function.prototype.name
      value
      isChecked
      onChecked: null
    }

  isChecked: =>
    return @state().isChecked

  setChecked: =>
    @state.set isChecked: true

  onChecked: (onCheckedFn) =>
    @state.set onChecked: onCheckedFn

  getValue: =>
    return @state().value

  render: ({label, inputName, value, isChecked, onChecked}) ->
    z 'div.z-input-radio',
      z 'label',
        z "input[type=radio][name=#{inputName}]
        #{if isChecked then '[checked]' else ''}", {
        value: value
        onchange: (e) ->
          if e.target.checked
            onChecked?()
        }
        label
