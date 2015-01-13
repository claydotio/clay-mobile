z = require 'zorium'
_ = require 'lodash'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputRadios extends InputBase
  constructor: ({radios}) ->
    styles.use()

    super

    # set first radio to checked if the client doesn't pass a checked one
    unless _.find radios, {isChecked: true}
      radios[0].isChecked = true

    @state.set {
      radios
    }

  setValue: (val) =>
    currentlyChecked = _.find @state().radios, {isChecked: true}
    unless newChecked
      return
    newChecked = _.find @state().radios, {value: val}
    currentlyChecked.isChecked = false
    newChecked.isChecked = true
    @state().checked = val

    @onchange? val

  getValue: =>
    checkedRadio = _.find @state().radios, {isChecked: true}
    return checkedRadio.value

  getInput: ({radios}) =>
    z 'div.z-input-radios',
      _.map radios, ({label, name, value, isChecked, onchecked}) =>
        z 'label',
          z "input[type=radio][name=#{name}]
          #{if isChecked then '[checked]' else ''}", {
          value: value
          onchange: (e) =>
            if e.target.checked
              @setValue value
          }
          label
