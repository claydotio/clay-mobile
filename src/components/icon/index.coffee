z = require 'zorium'

icons = require './icons.json'

styles = require './index.styl'

module.exports = class Icon
  constructor: ->
    styles.use()

  render: ({icon, size, touchTarget, color, onclick}) ->
    size ?= '24px'
    touchTarget ?= if size is '24px' and onclick then '48px' else size

    z 'div.z-icon', {
      onclick: onclick
      style:
        width: touchTarget
        height: touchTarget
        lineHeight: touchTarget
    },
      z 'svg', {
        namespace: 'http://www.w3.org/2000/svg'
        attributes:
          'viewBox': '0 0 24 24'
        style:
          width: size
          height: size
      },
        z 'path', {
          namespace: 'http://www.w3.org/2000/svg'
          attributes:
            d: icons[icon]
            fill: color
        }
