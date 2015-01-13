z = require 'zorium'
_ = require 'lodash'

styles = require './index.styl'

module.exports = class InputBlockRadio
  constructor: ({@radios, @onchange}) ->
    styles.use()

    @state = z.state {
      @radios
      checked: _.first Object.keys @radios
    }

    _.map @state().radios, (radio, val) =>
      if radio.isChecked()
        @state.set checked: val

      radio.onChecked =>
        @state.set checked: val
        @onchange? val

  getChecked: =>
    @state().radios[@state().checked]

  render: ({radios}) ->
    z 'div.z-input-block-radio',
      _.map radios, (radio) ->
        z 'div.radio-container', radio
