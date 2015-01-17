z = require 'zorium'
_ = require 'lodash'

InputBase = require '../input_base'

styles = require './index.styl'

module.exports = class InputRadios extends InputBase
  constructor: ({radios}) ->
    styles.use()

    super

    @state.set {
      radios
    }

  getInput$: =>
    {radios} = @state()
    z 'div.z-input-radios',
      _.map radios, (radio) =>
        z 'label',
          z "input[type=radio][name=#{radio.name}]", {
            checked: radio.value is @state.o_value()
            value: radio.value
            onchange: (e) =>
              if e.target.checked
                @state.o_value.set radio.value
          }
          radio.label
