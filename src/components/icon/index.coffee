z = require 'zorium'

icons = require './icons.json'

styles = require './index.styl'

module.exports = class Icon
  constructor: ->
    styles.use()

  render: ({icon, size, isAlignedTop, isAlignedLeft, isAlignedRight,
            isTouchTarget, color, onclick}) ->
    size ?= '24px'
    isTouchTarget ?= true

    z 'div.z-icon', {
      className: z.classKebab {isAlignedTop, isAlignedLeft, isAlignedRight,
                                isTouchTarget}
      onclick: onclick
      style:
        width: size
        height: size
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
