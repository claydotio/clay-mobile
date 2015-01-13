z = require 'zorium'

styles = require './index.styl'

module.exports = class InputBase
  constructor: (
    {
      hideLabel, label, labelWidth, value, theme, helpText, @onchange
    }
  ) ->
    styles.use()

    labelWidth ?= 100

    @state = z.state {
      hideLabel
      label
      labelWidth
      value
      theme
      helpText
      value
    }

  getInput: -> null

  getValue: =>
    @state().value

  setValue: (val) =>
    @state.set value: val
    @onchange? val

  render: ({hideLabel, label, helpText, labelWidth}) =>
    z 'div.z-input-base',
      z 'label.label',
        z 'div.l-flex.l-vertical-center.content',
          unless hideLabel
            z 'div.label-text', style: width: "#{labelWidth}px",
              label
          z 'div.l-flex-1.input-container',
            @getInput.apply null, arguments
            if helpText
              z 'i.icon.icon-help',
                title: helpText
