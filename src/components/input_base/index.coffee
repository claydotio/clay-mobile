z = require 'zorium'

styles = require './index.styl'

module.exports = class InputBase
  constructor: ({label, labelWidth, o_value, disabled, theme, helpText}) ->
    styles.use()

    labelWidth ?= 100

    @state = z.state {
      label
      labelWidth
      o_value
      disabled
      theme
      helpText
    }

  getInput$: -> null

  render: ({label, helpText, labelWidth}) =>
    z 'div.z-input-base',
      z 'label.label',
        z 'div.l-flex.l-vertical-center.content',
          if label
            z 'div.label-text', style: width: "#{labelWidth}px",
              label
          z 'div.l-flex-1.input-container',
            @getInput$()
            if helpText
              z 'i.icon.icon-help',
                title: helpText
                onclick: -> alert helpText
