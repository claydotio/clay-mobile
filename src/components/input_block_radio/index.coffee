z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class InputBlockRadio
  constructor: ({radios}) ->
    styles.use()

    @state = z.state {
      radios
      checked: 0
    }

    _.map @state().radios, (radio, i) =>
      if radio.isChecked()
        @state.set checked: i

      radio.onChecked =>
        @state.set checked: i

  getChecked: =>
    @state().radios[@state().checked]

  render: ({radios}) ->
    z 'div.z-input-block-radio',
      _.map radios, (radio) ->
        z 'div.radio-container', radio
