z = require 'zorium'

styles = require './index.styl'

module.exports = class InputSubdomain
  constructor: ({value, theme}) ->
    styles.use()

    @state = z.state {
      value
      theme
    }

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val

  render: ({value, theme}) =>
    z "div.z-input-subdomain#{if theme then theme else ''}",
      z 'input[type=text]',
        onkeyup: (e) =>
          @state.set value: e.target.value
        value: value

      z 'input[type=text][disabled].subdomain', value: 'clay.io'
