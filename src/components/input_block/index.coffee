z = require 'zorium'

styles = require './index.styl'

module.exports = class InputBlock
  constructor: ({label, labelWidth, @input, helpText}) ->
    styles.use()

    labelWidth ?= 100

    @state = z.state {
      label
      @input
      helpText
      labelWidth
    }

  render: ({label, input, helpText, labelWidth}) ->
    z 'div.z-input-block',
      z 'label',
        z 'div.l-flex.l-vertical-center',
          z 'div.label-text', style: width: "#{labelWidth}px",
            label
          z 'div.l-flex-1',
            input
            if helpText
              z 'i.icon.icon-help',
                title: helpText
