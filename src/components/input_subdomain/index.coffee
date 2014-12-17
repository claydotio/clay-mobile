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

  render: =>
    z "div.z-input-subdomain#{if @state().theme then @state().theme else ''}",
      z 'input[type=text]',
        onchange: (e) =>
          @state.set value: e.target.value
        value: @state().value

      z 'input[type=text][disabled].subdomain', value: 'clay.io'
